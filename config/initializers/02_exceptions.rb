exceptions = %w(
  PermissionDenied
  InvalidState
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
  DuplicatedMembership
  DuplicatedVacancy
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 