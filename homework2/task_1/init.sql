CREATE DATABASE elearning_db;

\c elearning_db;

CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    teacher_id INTEGER REFERENCES teachers(id) ON DELETE SET NULL
);

CREATE TABLE modules (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE lessons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    content TEXT,
    module_id INTEGER REFERENCES modules(id) ON DELETE CASCADE
);

--добавил таблицу enrollmets, т.к. связь  между таблицами students и courses M:N
CREATE TABLE enrollments (
    student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (student_id, course_id)
);

CREATE TABLE progress (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
    lesson_id INTEGER REFERENCES lessons(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('in_progress', 'completed')),
    completion_date DATE
);

--также как с enrollmets, добвил отдельно таблицы test(предполагаю тесты по модулям) и test_grades
--т.к. один студент может пройти несколько тестов и один тест может пройти несколько студентов
CREATE TABLE tests (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    module_id INTEGER REFERENCES modules(id) ON DELETE CASCADE
);

CREATE TABLE test_grades (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
    test_id INTEGER REFERENCES tests(id) ON DELETE CASCADE,
    grade INTEGER NOT NULL CHECK (grade BETWEEN 0 AND 100),
    grade_date DATE NOT NULL DEFAULT CURRENT_DATE
);