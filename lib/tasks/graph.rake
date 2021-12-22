require_relative '../../app/models/section/question_section'

namespace :graph do
  desc "Generate a graph in dot notation"
  task :plot, [:app_id] => [:environment] do |t, args|
    abort("you must provide an app id:  rake graph:plot[66]") unless args[:app_id]

    output = capture_digraph(args[:app_id])
    path = Rails.root.join 'tmp', "diagraph-#{args[:app_id]}"

    puts "Writing diagraph to #{path}"
    File.open(path, 'w') {|f| f.write(output) }

    graph_path = Rails.root.join 'tmp', "diagraph-#{args[:app_id]}.pdf"
    puts "Generating graph... #{graph_path}"
    if rv = system("dot -Tpdf #{path} -o #{graph_path}\n")
      puts "Graph generated. Openning..."
      system("open #{graph_path}")
    else
      puts "Unable to generate graph, please be sure you have graphviz installed, or copy the contents of #{path} to http://www.webgraphviz.com"
    end

  end
end

def capture_digraph(app_id)
  dg = "digraph G {\n"

  # TODO: Make application id as an argument to this rake task. By default set as 1
  SectionRule.where(sba_application_id: app_id, template_root_id: nil).each do |x|
    next unless Section.find_by(id: x.from_section_id)
    next unless Section.find_by(id: x.to_section_id)

    from_section = Section.find(x.from_section_id)
    to_section = Section.find(x.to_section_id)

    from_qps = from_section.question_presentations
    to_qps   = to_section.question_presentations


    from_title = "#{from_section.questionnaire.name}::#{from_section.ancestors.drop(1).map { |x| x.title }.join("::")}::#{from_section.title}\\n"
    to_title   = "#{from_section.questionnaire.name}::#{to_section.ancestors.drop(1).map { |x| x.title }.join("::")}::#{to_section.title}\\n"

    from_title = from_title + "#{from_qps.map { |x| "Question#{x.position}.id:#{x.question_id}" }.join("\\n")}"
    to_title   = to_title + "#{to_qps.map { |x| "Question#{x.position}.id:#{x.question_id}" }.join("\\n")}"
    dg << "        \"#{from_title}\" -> \"#{to_title}\" [ label = \"#{x.expression.to_json.gsub('"','')}\" ];\n"
  end

  dg << "}\n"

  dg
end