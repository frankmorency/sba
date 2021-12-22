class CasesPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  def wosb_cases
    browser.table(:text => "WOSB")
    browser.table(:text => "active")
  end

  def goto_cases
    browser.link(:text =>"Dashboard").wait_until_present(timeout: 10).click
  end

  def search_for_duns
    duns ="111419538" # Get from yml input
    browser.text_field(:id => "query").value = duns
    browser.send_keys :enter
  end

  def click_firm_link_on_results

  end
end
