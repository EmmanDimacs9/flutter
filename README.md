# flutter_application_1

**Project Overview**

This Flutter project is an **ICT Services Management System** designed to streamline and manage IT-related tasks, equipment, and personnel. The application features a multi-role login system (e.g., technician, admin), a dashboard, and several enhanced pages for managing tasks, viewing history, and handling user profiles.

**Main Features**

## Registration Page

The registration page allows new users to create an account by entering essential information such as name, email, password, department, and role. It ensures data validation and assigns the correct user role during sign-up. After registration, users can immediately log in and are directed to the appropriate dashboard. The page emphasizes a user-friendly experience with intuitive forms, helpful validation messages, and easy navigation back to the login screen.

## Login Page

The login page provides secure authentication for users, supporting multiple roles such as technicians and admins. It includes a "remember me" feature to keep users signed in across sessions, and validates credentials before granting access. Upon successful login, users are routed to their respective dashboards based on their role. The interface is designed for ease of use, with clear input fields, error feedback, and quick navigation to registration if needed.

- **Dashboard:** 

Personalized dashboard with time-based greetings, quick stats, and navigation to main features.

- **Task Management:**
  - 
  Enhanced task page with filtering (by status: All, Pending, In Progress, Completed & Overdue) and sorting (by due date, priority and more.).
  - Detailed task cards with progress tracking, priority, category, and assignment info.
  - Ability to start tasks, update progress, and view task details in a dialog.


- **History Page:**
  - Tabbed interface for viewing completed tasks, equipment scan history, and submitted reports.
  - Date range filtering and summary cards for quick stats.
  - Detailed lists for each history type, including ratings and notes for tasks, and summaries for reports.
- **Profile Page:**
  - Enhanced user profile with personal info, department, role, and join date.
  - Performance stats (tasks completed, equipment scanned, average rating, response time, completion rate).
  - Recent achievements and badges.
  - Settings for notifications, dark mode, sound, language, and privacy.
- **Equipment QR Scanner:**
  - (Mock UI) for scanning equipment QR codes and manual entry (feature placeholder).
- **Navigation:**
  - Bottom navigation bar for quick access to Home, Tasks, QR Scanner, History, and Profile.
- **Persistent Settings:** Uses `shared_preferences` for storing user settings and login state.

**File Structure Highlights**

---


- `lib/main.dart`: Entry point, app routing, and main navigation logic.
- `lib/enhanced_task_page.dart`: Advanced task management UI and logic.
- `lib/enhanced_history_page.dart`: Tabbed history view for tasks, equipment, and reports.
- `lib/enhanced_profile_page.dart`: User profile, stats, achievements, and settings.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
