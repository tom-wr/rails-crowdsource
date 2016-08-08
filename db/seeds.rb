# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Project.destroy_all

p1 = Project.create!({
  title: "Image Classification",
  subtitle: "Help classify the AAM image collection",
  description:"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam accumsan a nibh eu ultricies.",
  image: "134asdf.jpeg",
  avatar: "qwerasdf.jpeg"
})

p "Created #{Project.count} projects"

Taskflow.destroy_all

tf1 = Taskflow.create!({
    title: "taskflow1",
    description: "blah blah blah",
    project_id: p1.id
})

tf2 = Taskflow.create!({
    title: "taskflow2",
    description: "bleh bleh bleh",
    project_id: p1.id
})
p "Created #{Taskflow.count} taskflows"

Task.destroy_all

Task.create!([{
    title: "tasko uno",
    task_type: "2",
    help: "What are you going to do when they come for you",
    taskflow_id: tf1.id,
    data: [{text: "test", next: 1}, {text: "hoof", next: 1}]
},
{
    title: "tasko dos",
    task_type: "1",
    help: "What are you going to do when they come for you",
    taskflow_id: tf1.id
}])
p "Created #{Task.count} tasks"


Dataset.destroy_all

Dataset.create!([{
  title: "ds1",
  description: "the first ds",
  project_id: p1.id
}])
p "Created #{Dataset.count} datasets"

Survey.destroy_all

Survey.create!([{
  name: "Survey1",
  file: "survey_1"
}])
p "Created #{Survey.count} surveys"
