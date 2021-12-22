class SBAProfilesPage < GenericBasePage
  include DataHelper
  include PageActions
  include Associate_Upload

  def screen_shot()
    opts = {:page_height_limit => 5000}
    path = "features/screenshots/SBAProle_#{Time.now.strftime("%Y%m%d-%H%M%S")}.png"
    @browser.screenshot.save_stitch(path, @browser, opts)
  end

  def select_date(date)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    table.rows.each do |row|
      row.cells.each do |cell|
        if cell.text == "Initial" || cell.text == "#{date}"
          # varx = row.link.text
          # puts varx
          if row.link(:text => "#{var}").present?
            row.link(:text => "#{var}").click
            break
          end
        end
      end
    end
  end

  def assign(date)
    sleep 0.5
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    table.rows.each do |row|
      row.cells.each do |cell|
        #  puts cell.text
        if cell.text == "#{date}"
          # varx = row.link.text
          # puts varx
          row.link(:text => "Assign").click
          browser_status()
          break
        end
      end
    end
  end

  def select_district_office(date)
    select_date(date)
    # item = browser.fieldset(:class => "questions")
    # item.wait_until_present(timeout: 10).click
    browser.select(id: 'field_office').wait_until_present(timeout: 10).click
    browser.select(id: 'field_office').option(text: 'Philadelphia').select
    # item.parent.select_list().option(:text, "Philadelphia").select
    browser.div(:class => "actions").parent.button(:type => "submit").wait_until_present(timeout: 10).click
    browser.alert.wait_until_present(timeout: 2).ok
    dashboard_click()
  end

  def select_BOS(date)
    select_date(date)
    # item = browser.fieldset(:class => "questions")
    # item.wait_until_present(timeout: 10).click
    browser.select(id: 'field_office').wait_until_present(timeout: 10).click
    browser.select(id: 'field_office').option(text: 'Philadelphia').select
    # item.parent.select_list().option(:text, "Philadelphia").select
    browser.div(:class => "actions").parent.button(:type => "submit").wait_until_present(timeout: 10).click
    browser.alert.wait_until_present(timeout: 2).ok
    dashboard_click()
  end

  def unassigned_view()
    begin
      sleep 0.5
      unassigned = browser.section(:class => "dashboard-section")
      unassigned.parent.h2(:class => "dashboard-section__heading").text.include? "Unassigned Cases"
      unique_element_headers = unassigned.parent.table.thead.tr
      if unique_element_headers.present?
        unique_element_headers.text.include? "Date Submitted"
        unique_element_headers.text.include? "Type"
        unique_element_headers.text.include? "Applicant Firm"
        unique_element_headers.text.include? "Applicant Firm Location"
        unique_element_headers.text.include? "Actions"
        table = unassigned.parent.table
        sleep 0.5
        table.inspect
        begin
          if table.rows.length > 1
            #        puts "table is with data"
          elsif table.rows.length > 0
            #        puts "table is with some data"
          end
        end
      else
        raise "** No data is populated for supervisor-Scenario failed **"
        browser.close
      end
    end
  end

  def find_application(date, application)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    find_table_data(date,application,"#{var}")
    # unassigned = browser.section(:class => "dashboard-section".split)
    # table = unassigned.parent.table
    # table.trs.find {|tr| tr[0].text == "#{date}" && tr[1].text == "#{application}"}.present?

  end

  def find_table_data(date, application,company)
    unassigned = browser.section(:class => "dashboard-section".split)
    table = unassigned.parent.table
    table.trs.find {|tr| (tr[0].text == "#{date}" && tr[1].text == "#{application}") && (tr[2].text == "#{company}")}.present?

  end

  def find_application_status(application, status)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section".split)
    table = unassigned.parent.table
    table.trs.find {|tr| tr[0].text == "#{var}" && (tr[1].text == "#{application}" && tr[2].text == "#{status}")}.present?

  end

  def assign_application(date, application)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    puts var
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[2].text == "#{var}"}.present?
      table.links.each do |link|
        puts link.text
        if !link.text == "#{var}"
          # puts "Trying to find the case"

        elsif (link.text.include? "#{var}")
          #puts "Finding Link to Assign"
          #puts link.element(:xpath => './following::td/following::td').text
          if link.element(:xpath => './following::td/following::td').text == "Assign"
            link.element(:xpath => './following::td/following::td/a').click
          end
          browser_status()
          @browser.label(:text => /Analyst1/).click
          browser.div(:class => "actions").parent.input(:value => "Assign").wait_until_present(timeout: 10).click
          unique_element = browser.article(:id => "main-content").parent.h1()
          unique_element.text.include? "This case been assigned to Analyst1 Sba analyst 8a cods"
          break
        end
      end
    end
  end

  def assign_annual_review_application(date, application)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    #puts var
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[2].text == /#{var}/}.present?
      table.links.each do |link|
        #puts link.text
        if !link.text == "#{var}"
          #puts "Trying to find the case"

        elsif link.text == "#{var}"
          # puts link.element(:xpath => './following::td/following::td').text
          if link.element(:xpath => './following::td/following::td').text == "Assign"
            link.element(:xpath => './following::td/following::td/a').click
          end
          browser_status()
          @browser.label(:text => /Analyst1/).click
          browser.div(:class => "actions").parent.input(:value => "Assign").wait_until_present(timeout: 10).click
          unique_element = browser.article(:id => "main-content").parent.h1()
          unique_element.text.include? "This case been assigned to Analyst1 Sba analyst 8a district office"
          break
        end
      end
    end
  end

  def start_screening(date)
    dashboard_click()
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[0].text == /#{var}/ && tr[3].text == /#{date}/}.present?
      table.links.each do |link|
        #puts link.text
        if !link.text == "#{var}"
          # puts "Trying to find the case"

        elsif link.text.include? "#{var}"
          # puts "case found"
          link.wait_until_present(timeout: 10).click
          browser_status()
          assert_funbar("Screening",date)
          initial_begin_processing("Begin processing this case")

        end
      end
    else
      puts "No table is found with data"
    end
  end

  def click_screening(date)
    dashboard_click()
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    if table.trs.collect {|tr| (tr[0].text =~ /#{var}/) && (tr[3].text == /#{date}/)}.present?
      table.links.each do |link|
        #puts link.text
        if !link.text == "#{var}"
          # puts "Trying to find the case"

        elsif link.text.include? "#{var}"
          # puts "case found"
          link.wait_until_present(timeout: 10).click
          browser_status()
          assert_funbar("Screening",date)
          break
        end
      end
    else
      puts "No table is found with data"
    end
  end


  def start_processing_date(date)
    dashboard_click()
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section")
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[0].text == /#{var}/ && tr[3].text == /#{date}/}.present?
      table.links.each do |link|
        #puts link.text
        if !link.text == "#{var}"
          # puts "Trying to find the case"

        elsif link.text.include? "#{var}"
          # puts "case found"
          link.wait_until_present(timeout: 10).click
          browser_status()
          assert_funbar("Processing",date)
          break
        end
      end
    else
      puts "No table is found with data"
    end
  end


  def assign_station()
    if browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").present?
      #puts "Station assigned"

    elsif !browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").present?
      item = browser.fieldset(:class => "questions")
      item.parent.select_list().option(:text, "Philadelphia").select
      browser.div(:class => "actions").parent.button(:type => "submit").wait_until_present(timeout: 10).click
      browser.alert.wait_until_present(timeout: 2).ok
    end

  end

  def annual_review_screening(type,status,date)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    #puts "#{var}"
    browser_status()
    unassigned = browser.section(:class => "dashboard-section".split)
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[0].text.strip == "#{var}".strip}.present?
      #  if table.trs.find {|tr| (tr[1].text.strip == "#{type}".strip && tr[2].text.strip == "#{status}".strip) && (tr[2].text.strip == "#{date}".strip)}.present?
      # if table.trs.find {|tr| tr[1].text == "#{type}"}.present?
      table.links.each do |link|
        #  puts link.text
        if !link.text == "#{var}"
          #puts "Trying to find the case"

        elsif link.text.chomp == "#{var}".chomp
          # puts "case found"
          link.wait_until_present(timeout: 10).click
          browser_status()
          assert_funbar(status,date)
          break
        end
      end

    else
      puts "No table is found with data"

    end
  end

  def funbar_status(status)
    browser.div(:class => "taskbar".split).parent.divs(:class => "taskbar-section".split).each do |text_loop|
      # puts "First"
      # puts text_loop.p().text
      if !text_loop.p().text.include? "#{status}"
        puts "Status not found"
      elsif text_loop.p().text.include? "#{status}"
        puts "Status found"
        break

      end
    end

  end

  def funbar_date(date)
    browser.div(:class => "taskbar".split).parent.divs(:class => "taskbar-section hide-mobile".split).each do |text_loop|
      # puts "Second"
      # puts text_loop.p().text
      if !text_loop.p().text.include? "#{date}"
        puts "date not found"
        puts text_loop.p().text
        puts "Actual: >> #{date}"
      elsif text_loop.p().text.include? "#{date}"
        puts "date found"
        break

      end
    end

  end

  def assert_funbar(status,date)
    funbar_status(status)
    funbar_date(date)
    browser_status()
  end


  def initial_8a_processing(type, status, date)
    sleep 0.5
    browser_status()
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section".split).parent.h2(:text => "My Current Workload")
    table = unassigned.element(:xpath => './following::*')
    if table.trs.collect {|tr| tr[0].text == "#{var}"}.present?
      if table.trs.find {|tr| (tr[3].text.include? "#{date}") && (tr[1].text == "#{type}" && tr[2].text == "#{status}")}.present?
        table.links.each do |link|
          #   puts link.text
          if !link.text == "#{var}"
            #puts "Trying to find the case"

          elsif link.text == "#{var}"
            # puts "case found"
            link.wait_until_present(timeout: 10).click
            browser_status()
            break
          end
        end
      end
    end
  end

  def annual_review_processing(type, status, date)
    sleep 0.5
    var = comp_data_yml['Company']['Name'].strip
    unassigned = browser.section(:class => "dashboard-section".split)
    table = unassigned.parent.table
    if table.trs.collect {|tr| tr[0].text == "#{var}"}.present?
      # if table.trs.find {|tr| (tr[0].text.include? "#{var}") && (tr[3].text.include? "#{date}") && (tr[1].text == "#{type}" && tr[2].text == "#{status}")}.present?
      table.links.each do |link|
        if !link.text == "#{var}"

        elsif link.text == "#{var}"
          screen_shot()
          link.click
          browser_status()
          assert_funbar(status,date)
          break
        end
      end
      # end
    end
  end



  def initial_begin_processing(processing)
    if browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").present?
      browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").wait_until_present(timeout: 10).click
      fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu")
      fun_bar.parent.strong.a(:text => "#{processing}").wait_until_present(timeout: 10).click
      browser.input(:name => "commit").wait_until_present(timeout: 30).click
      frame_alert("Are you sure you want to begin processing?")
      browser.a(:text => "Return to application").wait_until_present(timeout: 10).click
    end

  end

  def annual_review_begin_processing(processing)
    if browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").present?
      browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").wait_until_present(timeout: 10).click
      fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu")
      fun_bar.parent.strong.a(:text => "#{processing}").wait_until_present(timeout: 10).click
      browser.input(:name => "commit").wait_until_present(timeout: 30).click
      frame_alert("Are you sure you want to begin processing?")
      browser.a(:text => "Return to application").wait_until_present(timeout: 10).click
    end

  end

  def annual_review_date_processing(state, date)
    annual_review_processing("Annual Review", state, date)
  end

  def initial_8a_date_processing(status, date)
    initial_8a_processing("Initial", status, date)
  end


  def sba_upload(processing)
    if browser.div(:class => "taskbar-actions".split).parent.button(:text => "Actions").present?
      browser.div(:class => "taskbar-actions".split).parent.button(:text => "Actions").wait_until_present(timeout: 10).click
      fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu".split)
      fun_bar.parent.lis.each do |all_li|
        if all_li.a(:text => "#{processing}").present?
          all_li.a(:text => "#{processing}").wait_until_present(timeout: 10).click
          browser_status()
          browser.element(:id => "dz-select-analyst-document").click
          file_location = data_pdf("#{_pdf_file}")
          sleep 0.5
          # puts "upload is in progress#"
          @browser.file_field().set file_location
          assert_complete_section("File added!", "In about 2 minutes, you can view the file. When it’s ready, the file name will be underlined.")
          browser_status()
          ###########****************************###################
          ## Note there is 2 minute delay to get active link to view the uploaded document, this portion of the code can be commented
          # browser.link(:text => "#{_pdf_file}").wait_until_present(timeout: 10).click
          # browser.window(:index => 1).use
          # browser_status()
          # browser.window(:index => 0).use
          # browser.window(:index => 1).close
          ############****************************##################

        end
      end
    end
  end

  def sba_funbar_action(processing)
    if browser.div(:class => "taskbar-actions".split).parent.button(:text => "Actions").present?
      browser.div(:class => "taskbar-actions".split).parent.button(:text => "Actions").wait_until_present(timeout: 10).click
      fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu".split)
      fun_bar.links.each do |link|
        # puts link
        # puts link.text
        if link.text.include? "#{processing}"
          link.wait_until_present(timeout: 10).click
          break
        end
      end
    end
  end


  def start_processing()
    browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").wait_until_present(timeout: 10).click
    fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu")
    fun_bar.parent.strong.a(:text => "Begin processing this case").wait_until_present(timeout: 10).click
    browser.div(:class => "usa-grid-full").wait_until_present(timeout: 10).click
    browser.h1.text.include? "Accept for processing?"
    browser.input(:name => "commit").wait_until_present(timeout: 30).click
    frame_alert("Are you sure you want to begin processing?")
    browser.a(:text => "Return to application").wait_until_present(timeout: 10).click
  end

  def add_note()
    #  browser.p(:text => "#{date}").span.text.includes "Next Action Due"
    #   browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").wait_until_present(timeout: 10).click
    #   # Add SBA Note
    #   fun_bar = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu")
    #   fun_bar.parent.li(:class => "task-panel-menu__item").wait_until_present(timeout: 10).click
    #
    #   sba_note = browser.div(:id => "note-main-popup").parent.form(:id => "new-note-form")
    #   sba_note_subject = sba_note.parent.fieldset(:class => "questions")
    #   sba_note_subject.input(:id => "note_subject").send_keys "Subject Note"
    #   sba_note_subject.textarea(:id => "note_message").send_keys "Subject Message Entered"
    #
    #

    #
    #     sba_note_tag = browser.div(:class => "certify-grid-wrap".split).parent.fieldset(:class => "question tags".split)
    #     sba_note_tag.parent.divs(:class => 'usa-width-one-third'.split).each do |ul_loop|
    #       ul_loop.ul(:class => "tag-selection-list".split).lis.each do |item|
    #         inputx = item.label(:text => "BOS Analysis")
    #         if inputx.exists?
    #           inputx.wait_until_present(timeout: 30).click
    #           break
    #         end
    #       end
    #     end
    #
    #     add_note = sba_note.parent.button(:id => "create_note").wait_until_present(timeout: 10).click
    #
    #
  end

  def current_workload_processing(date)

    browser.section(:class => "dashboard-section").parent.h2.text.include? "My Current Workload"
    my_notes = browser.h2(:text => "My Current Workload")
    unassigned = my_notes.element(:xpath => './following-sibling::*')

    table = unassigned.parent.table
    row = table.trs.find {|tr| tr[3].text.include? "#{date}"}
    row.th(:index => 0).a.click
  end

  def current_workload_status(status,date)
    var = comp_data_yml['Company']['Name'].strip
    browser.section(:class => "dashboard-section").parent.h2.text.include? "My Current Workload"
    my_notes = browser.h2(:text => "My Current Workload")
    unassigned = my_notes.element(:xpath => './following-sibling::*')

    table = unassigned.parent.table
    # row = table.trs.find {|tr|  (tr[2].text.strip.include? "#{status}")|| (tr[3].text.include? "#{date}")}
    if table.trs.collect {|tr| tr[0].text == "#{var}"}.present?
      if table.trs.find {|tr| (tr[3].text.include? "#{date}") && (tr[1].text == "Initial" && tr[2].text == "#{status}")}.present?
        puts "#{status}"
      end
    end
  end

  def funbar_action(value)
    browser_status()
    browser.div(:class => "taskbar-actions").parent.button(:text => "Actions").wait_until_present(timeout: 10).click

    # Make Recommendation

    fun_bar1 = browser.div(:id => "task-panel-fun-bar").parent.ul(:class => "task-panel-menu")

    fun_bar1.links.each do |link|
      # puts link
      # puts link.text
      if link.text.include? "#{value}"
        link.wait_until_present(timeout: 10).click
        puts "link is clicked"
        browser_status()
        break
      end
    end
  end

  def return_to_firm(action,status,date)
    funbar_action(action)
    browser.h1(:text => "Return to Firm for Revisions").present?
    radio_link = browser.element(:css => 'label')
    radio_link.wait_until_present(timeout: 10).click
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click
    browser.h1(:text => "Send Message to Firm").present?
    send_message_no_checkbox("Message to be sent return", "New message from analyst 15 day return letter","Next")
    browser.h1(:text => "This case has been returned to the firm.").present?
    dashboard_click()
    current_workload_status(status,date)
  end

  def analyst_make_recommendation(date)
    funbar_action("Make recommendation")

    browser.h4.text.include? "Would you recommend Entity 286 Legal Business Name as eligible for participation in the 8(a) Business Development Program?"
    radio_link = browser.li(:id => "reconsider_yes_li").parent.label(:for => "reconsider_yes")
    radio_link.wait_until_present(timeout: 10).click
    browser.div(:class => "actions").parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.a(:id => "dz-select-analysis-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location

    browser.a(:id => "dz-select-determination-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location
    browser.div(:class => "actions").parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.label(:text => /sba_supervisor_1 Sba supervisor 8a cods/).click
    browser.div(:class => "actions").parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.h1.text.include? "Review and Complete"
    browser.input(:value => "Complete recommendation").wait_until_present(timeout: 10).click

  end

  def supervisor_make_recommendation(date)

    funbar_action("Make recommendation")

    browser.h4.text.include? "Would you recommend Entity 286 Legal Business Name as eligible for participation in the 8(a) Business Development Program?"
    radio_link = browser.li(:id => "reconsider_yes_li").parent.label(:for => "reconsider_yes")
    radio_link.wait_until_present(timeout: 10).click
    browser.div(:class => "actions").parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.a(:id => "dz-select-analysis-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location

    browser.a(:id => "dz-select-determination-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.label(:text => /sba_supervisor_1 Sba supervisor 8a hq program/).click
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.h1.text.include? "Review and Complete"
    browser.input(:value => "Complete recommendation").wait_until_present(timeout: 10).click

  end

  def supervisor_hq_program_make_recommendation(date)

    funbar_action("Make recommendation")

    browser.h4.text.include? "Would you recommend Entity 286 Legal Business Name as eligible for participation in the 8(a) Business Development Program?"
    radio_link = browser.li(:id => "reconsider_yes_li").parent.label(:for => "reconsider_yes")
    radio_link.wait_until_present(timeout: 10).click
    browser.div(:class => 'actions'.split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.a(:id => "dz-select-analysis-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location

    browser.a(:id => "dz-select-determination-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.label(:text => /sba_supervisor_1 Sba supervisor 8a hq aa/).click
    browser.div(:class => 'actions'.split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.h1.text.include? "Review and Complete"
    browser.input(:value => "Save and continue").wait_until_present(timeout: 10).click

  end


  def supervisor_hq_aa_make_determination(date)
    funbar_action("Make determination")

    browser.h4.text.include? "What is your determination on Entity 468 Legal Business Name participation in the 8(a) Business Development Program?"
    radio_link = browser.li(:id => "reconsider_yes_li").parent.label(:for => "reconsider_yes")
    radio_link.wait_until_present(timeout: 10).click
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.a(:id => "dz-select-analysis-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location

    browser.a(:id => "dz-select-determination-document").wait_until_present(timeout: 10).click
    file_location = data_docx("#{_file}")
    sleep 0.5
    #       puts "upload is in progress#"
    @browser.file_field().set file_location
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    browser.label(:text => /sba_supervisor_1 Sba supervisor 8a cods/).click
    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    # Add SBA Note

    sba_note = browser.div(:class => "certify-grid-wrap".split).parent.fieldset(:class => "questions".split)
    sba_note.parent.input(:id => "note_subject").send_keys "Subject Note"
    sba_note.parent.textarea(:id => "note_message").send_keys "Subject Message Entered"

    sba_note_tag = browser.div(:class => "certify-grid-wrap".split).parent.fieldset(:class => "question tags".split)
    sba_note_tag.parent.divs(:class => 'usa-width-one-third'.split).each do |ul_loop|
      ul_loop.ul(:class => "tag-selection-list".split).lis.each do |item|
        inputx = item.label(:text => "BOS Analysis")
        if inputx.exists?
          inputx.wait_until_present(timeout: 30).click
          break
        end
      end
    end

    browser.div(:class => "actions".split).parent.input(:value => "Next").wait_until_present(timeout: 10).click

    # Send Message
    send_message_no_checkbox("Message to be sent", "New message from supervisor hq aa","Next")

    browser.h1.text.include? "Review and Complete"
    browser.input(:value => "Complete determination").wait_until_present(timeout: 10).click
    browser.div(:class => "certify-page-header__primary").h1.text.include? "#{$var_out}"
    browser.div(:class => "certify-page-header__primary").h1.text.include? "has been determined Eligible"
  end

  def send_message_short(message_subject,message_notes,button_value)
    browser.input(:id => "subject").send_keys "#{message_subject}"
    browser.div(:class => "ql-editor ql-blank".split).send_keys "#{message_notes}"
    browser.div(:class => "actions".split).parent.input(:value => "#{button_value}").wait_until_present(timeout: 10).click
  end

  def send_message_no_checkbox(message_subject,message_notes,button_value)
    send_message_short(message_subject, message_notes,button_value)
    browser.h1.text.include? "Review and Complete"
  end

  def send_deficiency_message(message_subject,message_notes)
    browser.input(:id => "subject").send_keys "#{message_subject}"
    browser.div(:class => "ql-editor ql-blank".split).send_keys "#{message_notes}"
    browser.div(:class => "actions".split).parent.input(:value => "Send Deficiency Letter").wait_until_present(timeout: 10).click
    browser.h1.text.include? "The Deficiency Letter has been sent to the firm owner"
  end

  def send_message(message_subject, message_notes,button_value1,button_value2)
    send_message_short(message_subject, message_notes,button_value1)
    browser.h1.text.include? "Review and Complete"
    browser.label(:text => "I used “Refer case within SBA” to get approval for this action.").wait_until_present(timeout: 10).click
    click_annual_review_button("#{button_value2}")
  end

  def send_message_terminate(message_subject,message_notes,button_value1,button_value2)
    send_message_short(message_subject, message_notes,button_value1)
    browser.h1.text.include? "Review your Letter of Intent to Terminate"
    browser.label(:text => "I used “Refer case within SBA” to get approval for this action.").wait_until_present(timeout: 10).click
    click_annual_review_button("#{button_value2}")
    browser.h1.text.include? "Your Letter of Intent to Terminate has been sent"
  end

  def annual_review_deficiency_letter()
    funbar_action("Send deficiency letter")
    if browser.h1(:text => "Write Deficiency Letter").present?
      assert_complete_section("The annual review will be returned to the firm", "Once you send this letter, the firm has 10 days to resubmit the Annual Review.")
      send_deficiency_message("AR Deficiency Letter from Analyst", "Analyst is sending deficiency letter for ANNUAL REVIEWS")
    else
      raise "no send deficiency letter flow found"
    end
  end



  def _file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'blue box prototype.docx'
  end

  def _pdf_file
    ENV['DATA_FILE'] ? ENV['DATA_FILE'] : 'Upload_Document.pdf'
  end

  def comp_file
    ENV['DATA_YML_FILE'] ? ENV['DATA_YML_FILE'] : 'comp_details.yml'
  end


end