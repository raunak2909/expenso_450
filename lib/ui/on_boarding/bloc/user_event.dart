abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  String email, mobNo, name, pass;

  CreateUserEvent({
    required this.email,
    required this.mobNo,
    required this.name,
    required this.pass,
  });
}

class AuthenticateUserEvent extends UserEvent{
  String email, pass;

  AuthenticateUserEvent({
    required this.email,
    required this.pass,
  });

}
