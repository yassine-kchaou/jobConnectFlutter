class ApiConstants {
  static const String baseUrl = 'http://localhost:3000';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String uploadAvatarEndpoint = '/auth/upload-avatar';
  static const String uploadIdentityPicEndpoint = '/auth/upload-identity-pic';
  static const String getUserEndpoint = '/auth/user';
  static const String usersEndpoint = '/users';

  // Job endpoints
  static const String jobsEndpoint = '/job';
  static const String jobByIdEndpoint = '/job';
  static const String jobByCityEndpoint = '/job/byCity';
  static const String jobByStartDateEndpoint = '/job/byStartDate';
  static const String jobByPriceAndTypeEndpoint = '/job/byPriceAndType';
  static const String jobByUserEndpoint = '/job/by-user';
  static const String createJobEndpoint = '/job/create';

  // Resume endpoints
  static const String resumesEndpoint = '/resumes';
  static const String resumeByIdEndpoint = '/resumes';
  static const String resumesByUserEndpoint = '/resumes/user';

  // Application endpoints
  static const String applicationsEndpoint = '/applications';
  static const String applicationsByStatusEndpoint = '/applications/status';
  static const String applicationsByJobEndpoint = '/applications/job';
  static const String applicationsByApplicantEndpoint =
      '/applications/byApplicant';
  static const String applicationsByEntrepriseEndpoint =
      '/applications/byEntreprise';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
