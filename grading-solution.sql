# SQL statements to generate grades database, and solve a series of challenges
SQL Grades CREATE SCHEMA `grades` ;

CREATE TABLE `grades`.`students` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

CREATE TABLE `grades`.`courses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

CREATE TABLE `grades`.`professors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE);

CREATE TABLE `grades`.`grades` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  `grade` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `student_id_idx` (`student_id` ASC) VISIBLE,
  INDEX `course_id_idx` (`course_id` ASC) VISIBLE,
  INDEX `professor_id_idx` (`professor_id` ASC) VISIBLE,
  CONSTRAINT `student_id`
    FOREIGN KEY (`student_id`)
    REFERENCES `grades`.`students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `course_id`
    FOREIGN KEY (`course_id`)
    REFERENCES `grades`.`courses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `professor_id`
    FOREIGN KEY (`professor_id`)
    REFERENCES `grades`.`professors` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

# only allow each student to enroll in a class once
ALTER TABLE grades ADD UNIQUE unique_index(student_id, course_id);

#Fix constraints on grades table
ALTER TABLE `grades`.`grades` 
DROP FOREIGN KEY `course_id`,
DROP FOREIGN KEY `professor_id`,
DROP FOREIGN KEY `student_id`;
ALTER TABLE `grades`.`grades` 
ADD INDEX `course_id_idx` (`course_id` ASC) VISIBLE,
DROP INDEX `course_id_idx` ;
;
ALTER TABLE `grades`.`grades` 
ADD CONSTRAINT `course_id`
  FOREIGN KEY (`course_id`)
  REFERENCES `grades`.`courses` (`id`)
  ON DELETE CASCADE,
ADD CONSTRAINT `professor_id`
  FOREIGN KEY (`professor_id`)
  REFERENCES `grades`.`professors` (`id`)
  ON DELETE CASCADE,
ADD CONSTRAINT `student_id`
  FOREIGN KEY (`student_id`)
  REFERENCES `grades`.`students` (`id`)
  ON DELETE CASCADE;

# Populate student table
INSERT INTO students(name) VALUES ("Kristine");
INSERT INTO students(name) VALUES ("John");
INSERT INTO students(name) VALUES ("Mary");
INSERT INTO students(name) VALUES ("Billy");
INSERT INTO students(name) VALUES ("Sue");
INSERT INTO students(name) VALUES ("Pat");
INSERT INTO students(name) VALUES ("Blake");

# Populate courses table
INSERT INTO courses(title) VALUES ("Fishing for Dummies");
INSERT INTO courses(title) VALUES ("Running for Dummies");
INSERT INTO courses(title) VALUES ("Jumping for Dummies");
INSERT INTO courses(title) VALUES ("Sleeping for Dummies");
INSERT INTO courses(title) VALUES ("Eating for Dummies");
INSERT INTO courses(title) VALUES ("Tripping for Dummies");

# Populate professors table
INSERT INTO professors(name) VALUES ("Mr Green");
INSERT INTO professors(name) VALUES ("Mr Black");
INSERT INTO professors(name) VALUES ("Mr White");
INSERT INTO professors(name) VALUES ("Mrs Red");
INSERT INTO professors(name) VALUES ("Mrs Blue");
INSERT INTO professors(name) VALUES ("Mrs Yellow");

# populate grades table
# repeat for lots of students
INSERT INTO grades(course_id, student_id, professor_id, grade) 
VALUES ((RAND()*5+1), (RAND()*6+1), (RAND()*5+1), (RAND()*40)+60);

#challenge 1: The average grade that is given by each professor
  SELECT AVG(grade) as AVG, name as Teacher FROM grades g, professors p WHERE g.professor_id = p.id GROUP BY professor_id ORDER BY AVG DESC

#challenge 2: The top grades for each student
  SELECT MAX(grade) as MAX, name as Student FROM grades g, students s WHERE g.student_id = s.id GROUP BY student_id ORDER BY MAX DESC

#challenge 3: Group students by the courses that they are enrolled in
  SELECT c.title as "Course Title", course_id as "Course ID", count(g.id) as "Students Enrolled" from grades as g, students as s, courses as c WHERE g.student_id = s.id AND g.course_id = c.id GROUP BY course_id

#challenge 4: Create a summary report of courses and their average grades, sorted by the most challenging course (course with the lowest average grade) to the easiest course
  SELECT AVG(grade) as AVG, title as "Course Title" FROM grades g, courses c WHERE g.course_id = c.id GROUP BY course_id ORDER BY AVG DESC

#challenge 5: Finding which student and professor have the most courses in common
  SELECT count(*), professor_id, student_id FROM grades GROUP BY professor_id, student_id ORDER BY count(*) DESC LIMIT 1;