# This observer is a hack so that we can observe state changes with the changes of the 
# workflow gem. On each transition we update the workflow_dirty flag to know that there
# was a change on of state that needs to be propagated to the Elasticsearch CasesIndex.
class ElasticObserver < ActiveRecord::Observer
  observe :certificate, :sba_application, :review

  def after_save(obj)
    if obj.workflow_dirty_changed?
      obj.update_column(:workflow_dirty, false)
    end
  end

end
