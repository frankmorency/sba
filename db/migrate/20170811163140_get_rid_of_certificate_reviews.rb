class GetRidOfCertificateReviews < ActiveRecord::Migration
  def change
    # The CertificateReview models have been cleaned up, so have to revert to SQL to do this one.
    execute <<-SQL
      update sbaone.reviews set type = 'Review::Initial' where type = 'CertificateReview::Initial';
    SQL
  end
end
