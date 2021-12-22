module DataTableHash
  def for_update
    self.select {|k, v| v['operation'] == 'update' }.map {|k, v| v }
  end

  def for_delete
    self.select {|k, v| v['operation'] == 'delete' && !v['id'].blank? }.map {|k, v| v }
  end

  def for_create
    self.select {|k, v| v['operation'] == 'create' }.map {|k, v| v }
  end

  def for_non_deleted
    self.select {|k, v| v['operation'] != 'delete' }.map {|k, v| v }
  end

  def brand_new_answered_for_ids=(v)
    @brand_new_answered_for_ids = v
  end

  def brand_new_answered_for_ids
    @brand_new_answered_for_ids
  end
end