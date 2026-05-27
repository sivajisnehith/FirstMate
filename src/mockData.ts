export const duplicateIssues = [
  {
    master_issue: 1204,
    master_title: 'App crashes when uploading large avatar',
    duplicate_issue: 1209,
    duplicate_title: 'Profile picture upload fails and closes app',
    confidence: 0.94,
    reason: 'Similar error logs and action trigger (avatar upload).',
  },
  {
    master_issue: 950,
    master_title: 'Dark mode toggle does not save state',
    duplicate_issue: 982,
    duplicate_title: 'Theme reverts to light mode after restart',
    confidence: 0.89,
    reason: 'Both describe theme persistence failure across app sessions.',
  },
];

export const prStatuses = [
  {
    number: 342,
    title: 'Feature: Add OAuth login providers',
    status: 'Has PR',
    daysOld: 2,
  },
  {
    number: 310,
    title: 'Refactor database migration scripts',
    status: 'STALLED',
    daysOld: 21,
  },
  {
    number: 345,
    title: 'Fix scrolling performance on list views',
    status: 'Has PR',
    daysOld: 1,
  },
  {
    number: 298,
    title: 'Update analytical tracking events',
    status: 'STALLED',
    daysOld: 35,
  },
];
