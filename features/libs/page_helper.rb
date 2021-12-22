module PageHelper
  def visit page_class, &block
    on page_class, true, &block
  end

  def on page_class, visit=false, &block
    page_class = class_from_string(page_class) if page_class.is_a? String
    page = page_class.new @browser, visit
    block.call page if block
    page
  end

  private

  def class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end
