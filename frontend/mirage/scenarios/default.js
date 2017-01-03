export default function(server) {

  server.loadFixtures("people", "competences", "advanced_trainings", "activities", "educations", "projects", "statues");
      /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.

    Make sure to define a factory for each model you want to create.
  */

  // server.createList('post', 10);
}
