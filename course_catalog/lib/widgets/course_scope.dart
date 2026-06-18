import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/course_level.dart';

class _CourseScope extends InheritedWidget{
  final List<Course> courses;
  final CourseScopeProviderState state;

  const _CourseScope({required this.courses, required this.state, required super.child});

  static _CourseScope of(BuildContext context){
    final result = context.dependOnInheritedWidgetOfExactType<_CourseScope>();
    assert(result != null, 'No CourseCatalog found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_CourseScope oldWidget) {
    return oldWidget.courses != courses;
  }

}

class CourseScopeProvider extends StatefulWidget{
  final Widget child;
  const CourseScopeProvider({super.key, required this.child});

  @override
  State<CourseScopeProvider> createState() => CourseScopeProviderState();

  static CourseScopeProviderState of(BuildContext context) {
    return _CourseScope.of(context).state;
  }
}

class CourseScopeProviderState extends State<CourseScopeProvider>{
  late List<Course> _courses;

  @override
  void initState() {
    super.initState();
    _courses = [
      Course(
      id: 1,
      title: "Программирование на Python с Нуля + Работа с SQL", 
      level: CourseLevel.beginner, 
      duration: "8 недель", 
      numberOfLessons: 48, 
      shortDescription: "Изучите Python с нуля, освоите работу с базами данных SQL и напишете свои первые проекты.",
      fullDescription: "Полный курс по Python: от установки интерпретатора до создания приложений с базами данных SQL. Вы научитесь работать с переменными, циклами, функциями, классами, а также освоите SQLite и PostgreSQL. В конце – дипломный проект.",
      ),
      Course(
        id: 2,
        title: "PRO C#. Профессия Backend разработчик", 
        level: CourseLevel.advanced, 
        duration: "12 недель", 
        numberOfLessons: 72, 
        shortDescription: "Глубокое погружение в C#, ASP.NET Core, создание REST API и микросервисов.",
        fullDescription: "Курс для опытных разработчиков. Изучите многопоточность, асинхронность, Entity Framework Core, развертывание микросервисов в Docker и Kubernetes. В конце – командная разработка проекта.",
        ),
      Course(
        id: 3,
        title: "Введение в программирование", 
        level: CourseLevel.beginner, 
        duration: "4 недели", 
        numberOfLessons: 24, 
        shortDescription: "Основы алгоритмов, переменных, циклов и условных операторов на практических примерах.",
        fullDescription: "Курс для абсолютных новичков. Вы узнаете, что такое алгоритмы, научитесь писать простые программы на псевдокоде и языке Python. Практические задания на каждой неделе.",
        ),
      Course(
        id: 4,
        title: "Основы программирования", 
        level: CourseLevel.beginner, 
        duration: "6 неделя",
        numberOfLessons: 32, 
        shortDescription: "Базовые концепции, структуры данных и простые алгоритмы для старта в IT.",
        fullDescription: "Расширенный курс для новичков: массивы, списки, стек, очередь, рекурсия, сортировки. Много практических задач и проектов.",
        ),
      Course(
        id: 5,
        title: "Java-разработчик", 
        level: CourseLevel.intermediate, 
        duration: "10 недель", 
        numberOfLessons: 60, 
        shortDescription: "Java Core, OOP, многопоточность, коллекции, работа с файлами и базами данных.",
        fullDescription: "Профессиональный курс по Java: от синтаксиса до многопоточности и работы с базами данных через JDBC и Hibernate. Включены реальные проекты.",
        ),
      Course(
        id: 6,
        title: "Старт в программировании", 
        level: CourseLevel.beginner, 
        duration: "3 недели", 
        numberOfLessons: 18, 
        shortDescription: "Быстрый старт: выбор языка, установка среды, написание первой программы.",
        fullDescription: "Интенсив для тех, кто хочет попробовать себя в IT. Расскажем о языках программирования, поможем выбрать направление и написать первый код.",
        ),
      Course(
        id: 7,
        title: "Full-Stack Engineer Career Path", 
        level: CourseLevel.intermediate, 
        duration: "16 недель", 
        numberOfLessons: 96, 
        shortDescription: "Полный путь full-stack разработчика: frontend (React) + backend (Node.js) + базы данных.",
        fullDescription: "Полный путь full-stack разработчика: HTML, CSS, JavaScript, React, Node.js, Express, MongoDB, PostgreSQL. Итоговый проект – полноценное веб-приложение.",
        ),
    ];
  }

  List<Course> get courses => _courses;

  Course? getCourseById(int id){
    try{
      return _courses.firstWhere((course) => course.id == id);
    }catch(e){
      return null;
    }
  }

  void toggleFavorite(int id) {
    setState(() {
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        final course = _courses[index];
        _courses = List.of(_courses);
        _courses[index] = course.copyWith(isFavorite: !course.isFavorite);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _CourseScope(
      courses: _courses, 
      state: this, 
      child: widget.child
    );
  }
}