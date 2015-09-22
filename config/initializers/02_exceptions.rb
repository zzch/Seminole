exceptions = %w(
  PermissionDenied
  DuplicatedPhone
  DuplicatedName
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 