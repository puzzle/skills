export default function(server) {

  server.loadFixtures("people", "competences", "advanced_trainings", "activities", "educations", "projects");
  /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.
  */

  // server.createList('post', 10);
}
