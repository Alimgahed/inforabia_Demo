import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'TAMER'**
  String get appName;

  /// No description provided for @employeeSwitch.
  ///
  /// In en, this message translates to:
  /// **'Employee Switch'**
  String get employeeSwitch;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Tamer Group Services'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Access all your healthcare and consumer self-services, leave requests, and digital ID in one place.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Business Analytics'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with company performance, attendance metrics, and regional benchmarks.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Bilingual & Secure'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Seamless support for Arabic and English with enterprise-grade biometric security.'**
  String get onboardingSubtitle3;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Face ID / Fingerprint'**
  String get biometricLogin;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get attendanceHistory;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @checkedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked Out'**
  String get checkedOut;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get onTime;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @todayStatus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Status'**
  String get todayStatus;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDays;

  /// No description provided for @presentDays.
  ///
  /// In en, this message translates to:
  /// **'Present Days'**
  String get presentDays;

  /// No description provided for @absentDays.
  ///
  /// In en, this message translates to:
  /// **'Absent Days'**
  String get absentDays;

  /// No description provided for @lateDays.
  ///
  /// In en, this message translates to:
  /// **'Late Days'**
  String get lateDays;

  /// No description provided for @leaveManagement.
  ///
  /// In en, this message translates to:
  /// **'Leave Management'**
  String get leaveManagement;

  /// No description provided for @leaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalance;

  /// No description provided for @requestLeave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get requestLeave;

  /// No description provided for @leaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Leave History'**
  String get leaveHistory;

  /// No description provided for @annualLeave.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave'**
  String get annualLeave;

  /// No description provided for @sickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sickLeave;

  /// No description provided for @unpaidLeave.
  ///
  /// In en, this message translates to:
  /// **'Unpaid Leave'**
  String get unpaidLeave;

  /// No description provided for @maternityLeave.
  ///
  /// In en, this message translates to:
  /// **'Maternity Leave'**
  String get maternityLeave;

  /// No description provided for @emergencyLeave.
  ///
  /// In en, this message translates to:
  /// **'Emergency Leave'**
  String get emergencyLeave;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @payslip.
  ///
  /// In en, this message translates to:
  /// **'Payslip'**
  String get payslip;

  /// No description provided for @payslipDetails.
  ///
  /// In en, this message translates to:
  /// **'Payslip Details'**
  String get payslipDetails;

  /// No description provided for @basicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary'**
  String get basicSalary;

  /// No description provided for @housingAllowance.
  ///
  /// In en, this message translates to:
  /// **'Housing Allowance'**
  String get housingAllowance;

  /// No description provided for @transportAllowance.
  ///
  /// In en, this message translates to:
  /// **'Transport Allowance'**
  String get transportAllowance;

  /// No description provided for @otherAllowances.
  ///
  /// In en, this message translates to:
  /// **'Other Allowances'**
  String get otherAllowances;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @deductions.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get deductions;

  /// No description provided for @socialInsurance.
  ///
  /// In en, this message translates to:
  /// **'Social Insurance'**
  String get socialInsurance;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Income Tax'**
  String get tax;

  /// No description provided for @netSalary.
  ///
  /// In en, this message translates to:
  /// **'Net Salary'**
  String get netSalary;

  /// No description provided for @salaryHistory.
  ///
  /// In en, this message translates to:
  /// **'Salary History'**
  String get salaryHistory;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @performanceReview.
  ///
  /// In en, this message translates to:
  /// **'Performance Review'**
  String get performanceReview;

  /// No description provided for @kpiTracking.
  ///
  /// In en, this message translates to:
  /// **'KPI Tracking'**
  String get kpiTracking;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get needsImprovement;

  /// No description provided for @myTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get myTeam;

  /// No description provided for @teamAttendance.
  ///
  /// In en, this message translates to:
  /// **'Team Attendance'**
  String get teamAttendance;

  /// No description provided for @teamByGender.
  ///
  /// In en, this message translates to:
  /// **'Team by Gender'**
  String get teamByGender;

  /// No description provided for @teamByGrade.
  ///
  /// In en, this message translates to:
  /// **'Team by Grade'**
  String get teamByGrade;

  /// No description provided for @headcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get headcount;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @documentOfRecord.
  ///
  /// In en, this message translates to:
  /// **'Document of Record'**
  String get documentOfRecord;

  /// No description provided for @worklist.
  ///
  /// In en, this message translates to:
  /// **'Worklist'**
  String get worklist;

  /// No description provided for @approvals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get approvals;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get news;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Latest Offers'**
  String get offers;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved'**
  String get allRightsReserved;

  /// No description provided for @solutionsConsultancy.
  ///
  /// In en, this message translates to:
  /// **'Solutions & Consultancy'**
  String get solutionsConsultancy;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @attendanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Attendance Overview'**
  String get attendanceOverview;

  /// No description provided for @approvalsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get approvalsPending;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not available on this device'**
  String get biometricsNotAvailable;

  /// No description provided for @hrPlatformDesc.
  ///
  /// In en, this message translates to:
  /// **'Access the premier HR services platform'**
  String get hrPlatformDesc;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get passwordTooShort;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @orConnectWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONNECT WITH'**
  String get orConnectWith;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get invalidName;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @createAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Join the enterprise HR digital transformation'**
  String get createAccountDesc;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreated;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @passportId.
  ///
  /// In en, this message translates to:
  /// **'Passport ID'**
  String get passportId;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get address;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContact;

  /// No description provided for @emergencyNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Number'**
  String get emergencyNumber;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @employmentInfo.
  ///
  /// In en, this message translates to:
  /// **'Employment Details'**
  String get employmentInfo;

  /// No description provided for @documentInfo.
  ///
  /// In en, this message translates to:
  /// **'Identity Documents'**
  String get documentInfo;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @joiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining Date'**
  String get joiningDate;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Direct Manager'**
  String get manager;

  /// No description provided for @requestsAndApprovals.
  ///
  /// In en, this message translates to:
  /// **'Requests & Approvals'**
  String get requestsAndApprovals;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @payrollAndFinance.
  ///
  /// In en, this message translates to:
  /// **'Payroll & Finance'**
  String get payrollAndFinance;

  /// No description provided for @hrInsights.
  ///
  /// In en, this message translates to:
  /// **'HR Insights'**
  String get hrInsights;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Business Overview'**
  String get businessOverview;

  /// No description provided for @totalHeadcount.
  ///
  /// In en, this message translates to:
  /// **'Total Headcount'**
  String get totalHeadcount;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'Budget Used'**
  String get budgetUsed;

  /// No description provided for @knowledgeAndAssets.
  ///
  /// In en, this message translates to:
  /// **'Knowledge & Assets'**
  String get knowledgeAndAssets;

  /// No description provided for @accrualBalances.
  ///
  /// In en, this message translates to:
  /// **'Accrual Balances'**
  String get accrualBalances;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @onLeave.
  ///
  /// In en, this message translates to:
  /// **'On Leave'**
  String get onLeave;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @avgPerformance.
  ///
  /// In en, this message translates to:
  /// **'Avg Performance'**
  String get avgPerformance;

  /// No description provided for @avgAttendance.
  ///
  /// In en, this message translates to:
  /// **'Avg Attendance'**
  String get avgAttendance;

  /// No description provided for @totalTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Total Team Members'**
  String get totalTeamMembers;

  /// No description provided for @taskCompletion.
  ///
  /// In en, this message translates to:
  /// **'Task Completion'**
  String get taskCompletion;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @latestPayslip.
  ///
  /// In en, this message translates to:
  /// **'Latest Payslip'**
  String get latestPayslip;

  /// No description provided for @previousPayslips.
  ///
  /// In en, this message translates to:
  /// **'Previous Payslips'**
  String get previousPayslips;

  /// No description provided for @promotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get promotion;

  /// No description provided for @annualIncrement.
  ///
  /// In en, this message translates to:
  /// **'Annual Increment'**
  String get annualIncrement;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// No description provided for @trainingList.
  ///
  /// In en, this message translates to:
  /// **'Training List'**
  String get trainingList;

  /// No description provided for @enrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get enrolled;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStarted;

  /// No description provided for @financialInsights.
  ///
  /// In en, this message translates to:
  /// **'Financial Insights'**
  String get financialInsights;

  /// No description provided for @departmentalPerformance.
  ///
  /// In en, this message translates to:
  /// **'Departmental Performance'**
  String get departmentalPerformance;

  /// No description provided for @genderDemographics.
  ///
  /// In en, this message translates to:
  /// **'Gender Demographics'**
  String get genderDemographics;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pendingApprovals;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @certificateRequest.
  ///
  /// In en, this message translates to:
  /// **'Certificate Request'**
  String get certificateRequest;

  /// No description provided for @purchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Purchase Order'**
  String get purchaseOrder;

  /// No description provided for @attendanceCorrection.
  ///
  /// In en, this message translates to:
  /// **'Attendance Correction'**
  String get attendanceCorrection;

  /// No description provided for @accrualBalanceAction.
  ///
  /// In en, this message translates to:
  /// **'Accrual Balance Action'**
  String get accrualBalanceAction;

  /// No description provided for @remoteWorkDays.
  ///
  /// In en, this message translates to:
  /// **'Remote Work Days'**
  String get remoteWorkDays;

  /// No description provided for @personalDays.
  ///
  /// In en, this message translates to:
  /// **'Personal Days'**
  String get personalDays;

  /// No description provided for @basicDataUpdate.
  ///
  /// In en, this message translates to:
  /// **'Basic Data Update'**
  String get basicDataUpdate;

  /// No description provided for @phoneData.
  ///
  /// In en, this message translates to:
  /// **'Phone Data'**
  String get phoneData;

  /// No description provided for @addressData.
  ///
  /// In en, this message translates to:
  /// **'Address Data'**
  String get addressData;

  /// No description provided for @educationalQualifications.
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get educationalQualifications;

  /// No description provided for @terminationOfServices.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get terminationOfServices;

  /// No description provided for @familyAndReferences.
  ///
  /// In en, this message translates to:
  /// **'Family & References'**
  String get familyAndReferences;

  /// No description provided for @leaveDelegationRules.
  ///
  /// In en, this message translates to:
  /// **'Delegation Rules'**
  String get leaveDelegationRules;

  /// No description provided for @extendedServices.
  ///
  /// In en, this message translates to:
  /// **'Extended Services'**
  String get extendedServices;

  /// No description provided for @specialistDashboard.
  ///
  /// In en, this message translates to:
  /// **'Specialist Dashboard'**
  String get specialistDashboard;

  /// No description provided for @performanceEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Performance Evaluation'**
  String get performanceEvaluation;

  /// No description provided for @goalsManagement.
  ///
  /// In en, this message translates to:
  /// **'Goals Management'**
  String get goalsManagement;

  /// No description provided for @continuousFeedback.
  ///
  /// In en, this message translates to:
  /// **'Continuous Feedback'**
  String get continuousFeedback;

  /// No description provided for @financialNotifications.
  ///
  /// In en, this message translates to:
  /// **'Finance Alerts'**
  String get financialNotifications;

  /// No description provided for @consolidatedEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get consolidatedEntries;

  /// No description provided for @procurement.
  ///
  /// In en, this message translates to:
  /// **'Procurement'**
  String get procurement;

  /// No description provided for @purchaseRequests.
  ///
  /// In en, this message translates to:
  /// **'Purchase Requests'**
  String get purchaseRequests;

  /// No description provided for @achievementCertificates.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achievementCertificates;

  /// No description provided for @itemTransfers.
  ///
  /// In en, this message translates to:
  /// **'Item Transfers'**
  String get itemTransfers;

  /// No description provided for @absencePlans.
  ///
  /// In en, this message translates to:
  /// **'Absence Plans'**
  String get absencePlans;

  /// No description provided for @salaryChanges.
  ///
  /// In en, this message translates to:
  /// **'Salary Changes'**
  String get salaryChanges;

  /// No description provided for @selfServices.
  ///
  /// In en, this message translates to:
  /// **'Self-Services'**
  String get selfServices;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @managerView.
  ///
  /// In en, this message translates to:
  /// **'Manager View'**
  String get managerView;

  /// No description provided for @hiresAndTerminations.
  ///
  /// In en, this message translates to:
  /// **'Hires & Terminations'**
  String get hiresAndTerminations;

  /// No description provided for @worklistManagement.
  ///
  /// In en, this message translates to:
  /// **'Worklist Management'**
  String get worklistManagement;

  /// No description provided for @teamSalaryByDept.
  ///
  /// In en, this message translates to:
  /// **'Avg Team Salary'**
  String get teamSalaryByDept;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @welcomeToInforabia.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TAMER'**
  String get welcomeToInforabia;

  /// No description provided for @welcomeToPanda.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tamer'**
  String get welcomeToPanda;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Theme'**
  String get chooseTheme;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startYourJourney;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @lightThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clean & Bright'**
  String get lightThemeSubtitle;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @darkThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Elegant & Modern'**
  String get darkThemeSubtitle;

  /// No description provided for @englishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'US English'**
  String get englishSubtitle;

  /// No description provided for @arabicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic Language'**
  String get arabicSubtitle;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Approvals & Tasks'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Swiftly manage corporate requests and task approvals directly from your mobile device.'**
  String get onboardingSubtitle4;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Tamer Rewards & Payroll'**
  String get onboardingTitle5;

  /// No description provided for @onboardingSubtitle5.
  ///
  /// In en, this message translates to:
  /// **'View your payslips and redeem exclusive Tamer colleague benefits.'**
  String get onboardingSubtitle5;

  /// No description provided for @onboardingTitle6.
  ///
  /// In en, this message translates to:
  /// **'Excellence & Growth'**
  String get onboardingTitle6;

  /// No description provided for @onboardingSubtitle6.
  ///
  /// In en, this message translates to:
  /// **'Join the Tamer Academy to sharpen your skills and advance your career path.'**
  String get onboardingSubtitle6;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @standardHRServices.
  ///
  /// In en, this message translates to:
  /// **'HR Self-Services'**
  String get standardHRServices;

  /// No description provided for @chatbotGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am HCM Assistant.\nHow can I help you today?'**
  String get chatbotGreeting;

  /// No description provided for @chatbotLeaveReply.
  ///
  /// In en, this message translates to:
  /// **'📅 Here are your leave balance details:'**
  String get chatbotLeaveReply;

  /// No description provided for @chatbotSalaryReply.
  ///
  /// In en, this message translates to:
  /// **'💰 Salary data for this month:'**
  String get chatbotSalaryReply;

  /// No description provided for @chatbotAttendanceReply.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Attendance and departure record today:'**
  String get chatbotAttendanceReply;

  /// No description provided for @chatbotApprovalsReply.
  ///
  /// In en, this message translates to:
  /// **'✅ Pending requests that need your approval:'**
  String get chatbotApprovalsReply;

  /// No description provided for @chatbotProfileReply.
  ///
  /// In en, this message translates to:
  /// **'👤 Your personal data and employment information:'**
  String get chatbotProfileReply;

  /// No description provided for @chatbotDocumentsReply.
  ///
  /// In en, this message translates to:
  /// **'📄 Documents and records available to you:'**
  String get chatbotDocumentsReply;

  /// No description provided for @chatbotRequestReply.
  ///
  /// In en, this message translates to:
  /// **'📝 I can help you submit a new request:'**
  String get chatbotRequestReply;

  /// No description provided for @chatbotDefaultReply.
  ///
  /// In en, this message translates to:
  /// **'🤖 I can help you with leaves, salary, attendance, approvals, documents, and more.'**
  String get chatbotDefaultReply;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNow;

  /// No description provided for @chooseFromQuickOptions.
  ///
  /// In en, this message translates to:
  /// **'Choose from quick options'**
  String get chooseFromQuickOptions;

  /// No description provided for @leaveKeyword.
  ///
  /// In en, this message translates to:
  /// **'leave'**
  String get leaveKeyword;

  /// No description provided for @salaryKeyword.
  ///
  /// In en, this message translates to:
  /// **'salary'**
  String get salaryKeyword;

  /// No description provided for @attendanceKeyword.
  ///
  /// In en, this message translates to:
  /// **'attendance'**
  String get attendanceKeyword;

  /// No description provided for @approvalKeyword.
  ///
  /// In en, this message translates to:
  /// **'approval'**
  String get approvalKeyword;

  /// No description provided for @documentKeyword.
  ///
  /// In en, this message translates to:
  /// **'document'**
  String get documentKeyword;

  /// No description provided for @dataKeyword.
  ///
  /// In en, this message translates to:
  /// **'data'**
  String get dataKeyword;

  /// No description provided for @requestKeyword.
  ///
  /// In en, this message translates to:
  /// **'request'**
  String get requestKeyword;

  /// No description provided for @performanceKeyword.
  ///
  /// In en, this message translates to:
  /// **'performance'**
  String get performanceKeyword;

  /// No description provided for @topTalentRetained.
  ///
  /// In en, this message translates to:
  /// **'Top Talent Retained'**
  String get topTalentRetained;

  /// No description provided for @totalEmployeesCount.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployeesCount;

  /// No description provided for @annualizedRetention.
  ///
  /// In en, this message translates to:
  /// **'Annualized Retention'**
  String get annualizedRetention;

  /// No description provided for @avgTenure.
  ///
  /// In en, this message translates to:
  /// **'Avg Tenure (yrs)'**
  String get avgTenure;

  /// No description provided for @predictedRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Predicted Retention by High Performer'**
  String get predictedRetentionTitle;

  /// No description provided for @predictedRetentionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Q2 2018 – Q2 2020'**
  String get predictedRetentionPeriod;

  /// No description provided for @highPerformance.
  ///
  /// In en, this message translates to:
  /// **'High Performance'**
  String get highPerformance;

  /// No description provided for @highPotential.
  ///
  /// In en, this message translates to:
  /// **'High Potential'**
  String get highPotential;

  /// No description provided for @topTalent.
  ///
  /// In en, this message translates to:
  /// **'Top Talent'**
  String get topTalent;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @retentionByBUTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Talent Retention by Business Unit'**
  String get retentionByBUTitle;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @humanResources.
  ///
  /// In en, this message translates to:
  /// **'Human Resources'**
  String get humanResources;

  /// No description provided for @researchAndDevelopment.
  ///
  /// In en, this message translates to:
  /// **'R&D'**
  String get researchAndDevelopment;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @predictedAttritionRisk.
  ///
  /// In en, this message translates to:
  /// **'Predicted Attrition Risk'**
  String get predictedAttritionRisk;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get lowRisk;

  /// No description provided for @mediumRisk.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get mediumRisk;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get highRisk;

  /// No description provided for @topTalentHeatMap.
  ///
  /// In en, this message translates to:
  /// **'Top Talent Heat Map'**
  String get topTalentHeatMap;

  /// No description provided for @performancePotential.
  ///
  /// In en, this message translates to:
  /// **'Performance × Potential'**
  String get performancePotential;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @med.
  ///
  /// In en, this message translates to:
  /// **'Med'**
  String get med;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @avgTenureYears.
  ///
  /// In en, this message translates to:
  /// **'Average Tenure (years)'**
  String get avgTenureYears;

  /// No description provided for @headcountDistribution.
  ///
  /// In en, this message translates to:
  /// **'Headcount Distribution'**
  String get headcountDistribution;

  /// No description provided for @femaleGenderRatio.
  ///
  /// In en, this message translates to:
  /// **'Female Gender Ratio'**
  String get femaleGenderRatio;

  /// No description provided for @womenRatio.
  ///
  /// In en, this message translates to:
  /// **'Women Ratio'**
  String get womenRatio;

  /// No description provided for @salaryOverview.
  ///
  /// In en, this message translates to:
  /// **'Salary Overview'**
  String get salaryOverview;

  /// No description provided for @goalsProgress.
  ///
  /// In en, this message translates to:
  /// **'Goals Progress'**
  String get goalsProgress;

  /// No description provided for @feedbackScore.
  ///
  /// In en, this message translates to:
  /// **'Feedback Score'**
  String get feedbackScore;

  /// No description provided for @performanceSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Performance Snapshot'**
  String get performanceSnapshot;

  /// No description provided for @retained.
  ///
  /// In en, this message translates to:
  /// **'Retained'**
  String get retained;

  /// No description provided for @quickRegistration.
  ///
  /// In en, this message translates to:
  /// **'Quick Registration'**
  String get quickRegistration;

  /// No description provided for @joinEnterprisePortal.
  ///
  /// In en, this message translates to:
  /// **'Join the enterprise portal in less than 2 minutes'**
  String get joinEnterprisePortal;

  /// No description provided for @performanceReviewDeadline.
  ///
  /// In en, this message translates to:
  /// **'Performance Review Deadline'**
  String get performanceReviewDeadline;

  /// No description provided for @trainingFlutterAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Training: Flutter Advanced'**
  String get trainingFlutterAdvanced;

  /// No description provided for @annualLeaveStart.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave Start'**
  String get annualLeaveStart;

  /// No description provided for @newsTitle1.
  ///
  /// In en, this message translates to:
  /// **'Tamer Logistics'**
  String get newsTitle1;

  /// No description provided for @newsDesc1.
  ///
  /// In en, this message translates to:
  /// **'Leading Third Party Strategic Logistics Service provider in the region.'**
  String get newsDesc1;

  /// No description provided for @newsTitle2.
  ///
  /// In en, this message translates to:
  /// **'LIFERA, SANOFI and ARABIO Sign MOU'**
  String get newsTitle2;

  /// No description provided for @newsDesc2.
  ///
  /// In en, this message translates to:
  /// **'Collaboration for vaccine manufacturing and supply in Saudi Arabia.'**
  String get newsDesc2;

  /// No description provided for @newsTitle3.
  ///
  /// In en, this message translates to:
  /// **'Healthy Partnerships'**
  String get newsTitle3;

  /// No description provided for @newsDesc3.
  ///
  /// In en, this message translates to:
  /// **'Healthcare excellence through close partnerships with multinationals.'**
  String get newsDesc3;

  /// No description provided for @newsTitle4.
  ///
  /// In en, this message translates to:
  /// **'Business Innovation'**
  String get newsTitle4;

  /// No description provided for @newsDesc4.
  ///
  /// In en, this message translates to:
  /// **'Driving cultural and strategic change in Saudi Arabia\'s pharmaceutical sector.'**
  String get newsDesc4;

  /// No description provided for @trackManageRequests.
  ///
  /// In en, this message translates to:
  /// **'Track, submit & manage your requests'**
  String get trackManageRequests;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get filterApproved;

  /// No description provided for @filterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterPending;

  /// No description provided for @filterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get filterRejected;

  /// No description provided for @totalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalRequests;

  /// No description provided for @prsCertsWarehouse.
  ///
  /// In en, this message translates to:
  /// **'PRs, achievement certs & warehouse'**
  String get prsCertsWarehouse;

  /// No description provided for @prsShort.
  ///
  /// In en, this message translates to:
  /// **'PRs'**
  String get prsShort;

  /// No description provided for @certsShort.
  ///
  /// In en, this message translates to:
  /// **'Certs'**
  String get certsShort;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @percentComplete.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Complete'**
  String percentComplete(Object percent);

  /// No description provided for @docsPoliciesTraining.
  ///
  /// In en, this message translates to:
  /// **'Documents, policies & training courses'**
  String get docsPoliciesTraining;

  /// No description provided for @docsShort.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docsShort;

  /// No description provided for @coursesShort.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get coursesShort;

  /// No description provided for @doneShort.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneShort;

  /// No description provided for @activeShort.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeShort;

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String pagesCount(Object count);

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeCount(Object count);

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Completed'**
  String completedCount(Object count);

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @workProgress.
  ///
  /// In en, this message translates to:
  /// **'Work progress'**
  String get workProgress;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @tapToCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Tap to Check-Out'**
  String get tapToCheckOut;

  /// No description provided for @workDayComplete.
  ///
  /// In en, this message translates to:
  /// **'Work day complete'**
  String get workDayComplete;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanning;

  /// No description provided for @tapToCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Tap to Check-In'**
  String get tapToCheckIn;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get biometric;

  /// No description provided for @checkInWith.
  ///
  /// In en, this message translates to:
  /// **'Check-In with'**
  String get checkInWith;

  /// No description provided for @checkOutWith.
  ///
  /// In en, this message translates to:
  /// **'Check-Out with'**
  String get checkOutWith;

  /// No description provided for @checkInShort.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get checkInShort;

  /// No description provided for @checkOutShort.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get checkOutShort;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @requestAbsence.
  ///
  /// In en, this message translates to:
  /// **'Request Absence'**
  String get requestAbsence;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @transferred.
  ///
  /// In en, this message translates to:
  /// **'Transferred'**
  String get transferred;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'Mins'**
  String get mins;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @viewMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'View Monthly Report'**
  String get viewMonthlyReport;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @approveAll.
  ///
  /// In en, this message translates to:
  /// **'Approve All'**
  String get approveAll;

  /// No description provided for @softwareEngineer.
  ///
  /// In en, this message translates to:
  /// **'Software Engineer'**
  String get softwareEngineer;

  /// No description provided for @itDept.
  ///
  /// In en, this message translates to:
  /// **'IT Department'**
  String get itDept;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @salaryCertificate.
  ///
  /// In en, this message translates to:
  /// **'Salary Certificate'**
  String get salaryCertificate;

  /// No description provided for @recommendationLetter.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Letter'**
  String get recommendationLetter;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @salaryLoanRequest.
  ///
  /// In en, this message translates to:
  /// **'Salary Loan Request'**
  String get salaryLoanRequest;

  /// No description provided for @officialEntityRequest.
  ///
  /// In en, this message translates to:
  /// **'Official Entity Request'**
  String get officialEntityRequest;

  /// No description provided for @dataUpdate.
  ///
  /// In en, this message translates to:
  /// **'Data Update'**
  String get dataUpdate;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update Personal Info'**
  String get updatePersonalInfo;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @sick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get sick;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @workFromHome.
  ///
  /// In en, this message translates to:
  /// **'Work From Home'**
  String get workFromHome;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to proceed'**
  String get biometricReason;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in recorded successfully'**
  String get checkInSuccess;

  /// No description provided for @checkInSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Check-In Successful'**
  String get checkInSuccessful;

  /// No description provided for @welcomeDayMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Have a productive day.'**
  String get welcomeDayMessage;

  /// No description provided for @checkOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-out recorded successfully'**
  String get checkOutSuccess;

  /// No description provided for @checkOutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Check-Out Successful'**
  String get checkOutSuccessful;

  /// No description provided for @greatWorkMessage.
  ///
  /// In en, this message translates to:
  /// **'Great work today! See you tomorrow.'**
  String get greatWorkMessage;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @genderRatioTitle.
  ///
  /// In en, this message translates to:
  /// **'Men Ratio'**
  String get genderRatioTitle;

  /// No description provided for @onboardingTitle7.
  ///
  /// In en, this message translates to:
  /// **'Smart Workplace'**
  String get onboardingTitle7;

  /// No description provided for @onboardingSubtitle7.
  ///
  /// In en, this message translates to:
  /// **'Experience a seamless digital workplace designed for the modern employee.'**
  String get onboardingSubtitle7;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @gosi.
  ///
  /// In en, this message translates to:
  /// **'GOSI'**
  String get gosi;

  /// No description provided for @absenceDeduction.
  ///
  /// In en, this message translates to:
  /// **'Absence Deduction'**
  String get absenceDeduction;

  /// No description provided for @financialAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Financial Analysis'**
  String get financialAnalysis;

  /// No description provided for @salaryTrend.
  ///
  /// In en, this message translates to:
  /// **'Salary Trend'**
  String get salaryTrend;

  /// No description provided for @rising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get rising;

  /// No description provided for @falling.
  ///
  /// In en, this message translates to:
  /// **'Falling'**
  String get falling;

  /// No description provided for @leaveAndAttendance.
  ///
  /// In en, this message translates to:
  /// **'Leave & Attendance'**
  String get leaveAndAttendance;

  /// No description provided for @salaryAndFinance.
  ///
  /// In en, this message translates to:
  /// **'Salary & Finance'**
  String get salaryAndFinance;

  /// No description provided for @personalAndEmployment.
  ///
  /// In en, this message translates to:
  /// **'Personal & Employment'**
  String get personalAndEmployment;

  /// No description provided for @performanceAndGrowth.
  ///
  /// In en, this message translates to:
  /// **'Performance & Growth'**
  String get performanceAndGrowth;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
