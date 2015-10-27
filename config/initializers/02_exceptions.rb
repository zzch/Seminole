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
  UndeterminedItem
  InvalidCardType
  InvalidCharingType
  InsufficientBall
  InsufficientMinute
  InsufficientDeposit
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 