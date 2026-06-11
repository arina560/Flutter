import 'models/course.dart';
import 'widgets/course_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CourseListScreen(),
    );
  }
}

class CourseListScreen extends StatelessWidget{
  const CourseListScreen({super.key});
  
  final List<Course> courses = const[
    Course(
      title: "Программирование на Python с Нуля + Работа с SQL", 
      level: "Начинающий", 
      duration: "8 недель", 
      numberOfLessons: 48, 
      description: "Изучите Python с нуля, освоите работу с базами данных SQL и напишете свои первые проекты.",
      ),
    Course(
      title: "PRO C#. Профессия Backend разработчик", 
      level: "Продвинутый", 
      duration: "12 недель", 
      numberOfLessons: 72, 
      description: "Глубокое погружение в C#, ASP.NET Core, создание REST API и микросервисов.",
      ),
    Course(
      title: "Введение в программирование", 
      level: "Начинающий", 
      duration: "4 недели", 
      numberOfLessons: 24, 
      description: "Основы алгоритмов, переменных, циклов и условных операторов на практических примерах.",
      ),
    Course(
      title: "Основы программирования", 
      level: "Начинающий", 
      duration: "6 неделя",
      numberOfLessons: 32, 
      description: "Базовые концепции, структуры данных и простые алгоритмы для старта в IT.",
      ),
    Course(
      title: "Java-разработчик", 
      level: "Средний", 
      duration: "10 недель", 
      numberOfLessons: 60, 
      description: "Java Core, OOP, многопоточность, коллекции, работа с файлами и базами данных.",
      ),
    Course(
      title: "Старт в программировании", 
      level: "Начинающий", 
      duration: "3 недели", 
      numberOfLessons: 18, 
      description: "Быстрый старт: выбор языка, установка среды, написание первой программы.",
      ),
    Course(
      title: "Full-Stack Engineer Career Path", 
      level: "Средний", 
      duration: "16 недель", 
      numberOfLessons: 96, 
      description: "Полный путь full-stack разработчика: frontend (React) + backend (Node.js) + базы данных.",
      ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programming courses"),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index){
          final course = courses[index];
          return CourseCard(course: course);
        },
      ),
    );
  }}
