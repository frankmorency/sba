require 'csv'

module Exporter
  class Dsbs < Base
    protected

    def row_converter(row)
      row['duns'] = row['duns']&.rjust(9, '0')
      row['tax_id'] = row['tax_id']&.rjust(9, '0')
      row['case_number'] = 'C' + IdCompressor.compress(row['case_number']&.to_i, 5)

      row
    end

    def query
      <<~QUERY
      SET search_path TO sbaone;
      SELECT
        orgs.duns_number AS "duns",
        sam_orgs.tax_identifier_number AS "tax_id",
        CASE WHEN sam_orgs.tax_identifier_type = 'EIN' THEN '0' ELSE '1' END AS "tax_id_type",
        certs.id AS "case_number",
        CASE certs.workflow_state WHEN 'active' THEN 'active' ELSE 'inactive' END AS workflow_state,
        1 AS "type",
        to_char(certs.issue_date::date, 'dd-Mon-YY') AS "entry_date",
        to_char(certs.expiry_date::date, 'dd-Mon-YY') AS "exit_date",
        'Certify' AS created_by_id,
        to_char(certs.created_at::date, 'dd-Mon-YY') AS "created_by_date",
        COALESCE(hists.evaluator_id::text, 'Certify') AS "last_updated_id",
        COALESCE(users.email, 'Certify') AS "last_updated_email",
        to_char(COALESCE(hists.created_at::date, certs.updated_at::date), 'dd-Mon-YY') AS "last_updated_date"
      FROM certificates certs
      INNER JOIN organizations orgs ON orgs.id = certs.organization_id
      INNER JOIN reference.mvw_sam_organizations sam_orgs ON orgs.duns_number = sam_orgs.duns
      INNER JOIN (
         SELECT
             a.certificate_id, max(a.id) AS id
         FROM
             sbaone.sba_applications a
             INNER JOIN sbaone.reviews r ON a.id = r.sba_application_id
         WHERE
             a.deleted_at IS NULL AND
             (
                 (a.type = 'SbaApplication::EightAAnnualReview' AND r.workflow_state = 'retained') OR
                 (bdmis_case_number IS NULL AND a.type = 'SbaApplication::EightAMaster')
             )
         GROUP BY
             a.certificate_id
          ) apps ON
              apps.certificate_id = certs.id
      LEFT OUTER JOIN evaluation_histories hists ON
        hists.evaluable_id = apps.id AND
        hists.evaluable_type LIKE 'SbaApplication%' AND
        hists.deleted_at IS NULL AND
        hists.id = (
          SELECT
            MAX(id)
          FROM
            evaluation_histories
          WHERE
            evaluation_histories.category = 'determination' AND
            evaluation_histories.evaluable_id = apps.id AND
            evaluation_histories.evaluable_type LIKE 'SbaApplication%'
        )
      LEFT OUTER JOIN users ON
        users.id = hists.evaluator_id
      WHERE
        certs.type = 'Certificate::EightA' AND
        certs.workflow_state IN ('active','inactive','expired','closed','ineligible','voluntary_withdrawn','early_graduated','terminated','graduated','withdrawn') AND
        certs.deleted_at IS NULL AND
        certs.issue_date IS NOT NULL AND certs.expiry_date IS NOT NULL AND
        (certs.issue_date > (current_timestamp - interval '24 hours') or certs.updated_at > (current_timestamp - interval '24 hours'))
      ORDER BY duns;
      QUERY
    end

    def headers
      %w(
        duns tax_id tax_id_type case_number A type entry_date exit_date created_by_id created_by_date
        last_updated_id last_updated_email last_updated_date
      )
    end
  end
end
