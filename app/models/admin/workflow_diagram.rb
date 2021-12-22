module Admin
  class WorkflowDiagram
    def self.generate!(klass)
      graph = ::GraphViz.new('G', :rankdir => 'LR', :ratio => 'fill')
      klass.workflow_spec.states.each do |_, state|
        node = state.draw(graph)
        node.fontname = 'Helvetica'

        state.events.flat.each do |event|
          edge = event.draw(graph, state)
          edge.fontname = 'Helvetica'
        end
      end

      # Generate the graph
      filename = Rails.root.join('public', 'workflow', "#{"#{klass.name.tableize.split('/').join('_')}_workflow"}.png")
      graph.output 'png' => "#{filename}"
    end
  end
end