module Associate_Upload
  def document_original(value, key, _file)
    begin
      associate_document_original_modified(value, key, _file)
    end
  end

  def upload_file(key, _file)
    begin
      sleep 0.5
      link = browser.div(class: "dz-default dz-message".split).parent.a(id: "#{key}")
      link.inspect
      link.wait_until_present(timeout: 30).click
      file_location = data_pdf("#{_file}")
      sleep 0.5
      #       puts "upload is in progress#"
      @browser.file_field().set file_location
      sleep 0.5
      #       puts "upload is in progress###"
      @browser.table(:id => "file_list_append").parent.input(id: "comment").wait_until_present(timeout: 20).send_keys "#{_file} : file uploaded"
      sleep 0.5
      upload_button.wait_until_present(timeout: 30).click
      sleep 0.5
      #       puts "upload is completed###"
      table = @browser.table(:id => "currently_attached")
      starting_row_index = browser.table.rows.to_a.index { |row| row.td(:id => "document_library_file_name", :text => "#{_file}").present? }
      browser_status()
    end
  end

  def associate_document_original_modified(value, key, _file)
    begin
      browser.send_keys(:page_down)
      sleep 0.5
      item = browser.divs(:class => "sba-c-question__primary-text".split)
      item.each do |textloop|
        if textloop.text.include? "#{value}"
          item1 = textloop.element(:xpath => "./following::div")
          button_associate = item1.parent.div(class: "add-req-doc".split).a(href: "javascript:void(0)").i(class: "fa fa-plus-circle".split)
          button_associate.wait_until_present(timeout: 10).click
          browser.send_keys(:page_down)
          sleep 0.5
          link = button_associate.element(:xpath => "./following::div")
          linked = link.parent.button(:id => "doc-lib-button")
          linked.inspect
          linked.wait_until_present(timeout: 10).click
          sleep 0.5
          table = browser.table(:class => "display-table".split)
          sleep 0.5
          table.inspect
          #puts table.rows.length
          if table.rows.length == 1 || table.rows.length == 0
            sleep 0.5
            up_linked = link.parent.button(:id => "doc-upload-button")
            up_linked.inspect
            up_linked.wait_until_present(timeout: 10).click
            browser_status()
            upload_file(key, _file)
            sleep 0.5
          elsif table.rows.length > 2 || table.rows.length == 2
            browser.send_keys(:page_down)
            sleep 0.5
            item1.parent.table(class: "display-table".split).tbody().tr.td(id: "document_library_file_name").ul().li().label().click
            item1.parent.div(class: "right-align".split).div.button(id: "document_library_associate").click
            browser_status()
            sleep 0.5
            break
          end
        end
      end
    end
  end

  class << self
    attr_accessor :associate_document_original_modified,
                  :document_original,
                  :upload_file
  end
end
