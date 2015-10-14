exceptions = %w(
  PermissionDenied
  DuplicatedPhone
  DuplicatedName
  InvalidCard
  InvalidMember
  CannotBeBlank
  DoesNotExist
  AlreadyInUse
  InvalidParameter
  UserNotFound
  UnactivatedUser
  IncorrectVerificationCode
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 