const routeLoading = 'Loading';
const routeLanding = 'Landing';
const routeHome = 'Home';
const routeChores = 'Chores';
const routeGroups = 'Groups';
const routeTables = 'Tables';
const routeSettings = 'Settings';

const initialAppRoute = routeSettings;
const appRoutes = [
  routeHome,
  routeChores,
  routeGroups,
  routeTables,
  routeSettings,
];
indexOfDefaultRoute () => appRoutes.indexOf(initialAppRoute);