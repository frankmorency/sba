if Feature.active?(:elasticsearch)
  Chewy.use_after_commit_callbacks = !Rails.env.test?
  Chewy.strategy(:atomic)
end
