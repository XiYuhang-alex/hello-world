// ===========================================================================
// hello_world · lib/main.dart —— 逐行中文注释版（课堂案例复现）
// 功能：Flutter 官方计数器示例，与《实践指南一》第五章案例一致，行为不变。
// 注释规范：每一行代码上方或右侧均有中文注释，解释"这行代码做了什么、为什么需要"。
// ===========================================================================

// 第1行：导入 Flutter Material 设计库。
// material.dart 包含 MaterialApp、Scaffold、AppBar、Text 等几乎所有常用 Widget，
// 是编写 Material 风格界面必导入的核心库。
import 'package:flutter/material.dart';

// 第3行：main() 是 Dart 程序的入口函数，应用启动后最先执行这里。
// void 表示该函数没有返回值。
void main() {
  // 第4行：runApp() 把根组件（root widget）挂载到屏幕上，
  // 它会持有生成的 WidgetTree（组件树）并交给 Flutter 渲染引擎绘制。
  // const MyApp() 表示编译期常量构造，多个 const 实例共享同一内存，节省开销。
  runApp(const MyApp());
}

// 第7行：MyApp 是整个应用的根 Widget。
// 继承 StatelessWidget（无状态组件）：它的外观不随运行时数据变化，
// 没有需要自己保存的可变状态，界面只由传入的配置决定。
class MyApp extends StatelessWidget {
  // 第8行：构造函数。{super.key} 把传给 MyApp 的 key 参数上交给父类 Widget，
  // key 用于框架在 Widget 树重建时标识、比较组件。
  const MyApp({super.key});

  // 第11行：@override 注解，表示下面要重写（覆盖）父类 StatelessWidget 的方法。
  @override
  // 第12行：build() 描述"这个组件长什么样"，返回一张组件说明书（Widget 树）。
  // context 是 BuildContext，代表本组件在组件树中的位置句柄，
  // 后面靠它向上查找主题（Theme.of(context)）。
  Widget build(BuildContext context) {
    // 第13行：返回 MaterialApp —— 应用级容器，负责全局主题、路由、标题。
    return MaterialApp(
      // 第14行：应用标题，任务切换器里显示的名字（Android 上还会用作应用标签）。
      title: 'Flutter Demo',
      // 第15行：theme 定义全局视觉主题。ThemeData 是主题数据类。
      theme: ThemeData(
        // 第31行：colorScheme 从一个种子色生成整套配色方案。
        // seedColor: Colors.deepPurple 以深紫色为基调自动派生主色、辅助色等。
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // 第33行：home 指定应用首页（启动后看到的第一个页面）。
      // const 表示该页面配置编译期即可确定，title 传入字符串常量。
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// 第38行：MyHomePage 是应用首页，继承 StatefulWidget（有状态组件）。
// 为什么有状态？因为页面上的计数器数值会随点击不断变化。
// StatefulWidget 本身只是"配置说明书"，真正的可变数据存放在它对应的 State 对象里。
class MyHomePage extends StatefulWidget {
  // 第39行：构造函数。required this.title 表示 title 是必填命名参数。
  const MyHomePage({super.key, required this.title});

  // 第50行：页面的标题字符串。final 表示赋值后不可再改——
  // Widget（配置）永远不可变，这是 Flutter 高效 diff 的前提。
  final String title;

  // 第52行：重写父类方法，要求创建本 Widget 对应的 State 对象。
  @override
  // 第53行：createState() 返回 _MyHomePageState 实例，
  // Flutter 框架据此把"配置(MyHomePage)"和"可变状态(_MyHomePageState)"绑定起来。
  State<MyHomePage> createState() => _MyHomePageState();
}

// 第56行：_MyHomePageState 保存首页全部可变状态。
// 下划线开头表示 Dart 库级私有，只能在 main.dart 文件内访问。
// extends State<MyHomePage> 泛型指明它服务于哪个 Widget。
class _MyHomePageState extends State<MyHomePage> {
  // 第57行：计数器变量，初始值为 0，每次点击按钮后加一。
  int _counter = 0;

  // 第59行：点击悬浮按钮时被调用的方法。
  void _incrementCounter() {
    // 第60行：setState() 通知框架"本 State 的数据变了，请重新执行 build()"。
    // 它接收一个回调，回调里做数据修改；不包在 setState 里改数据，界面不会刷新。
    setState(() {
      // 第66行：计数器自增一。这一行执行完，build() 随即被框架重新调度。
      _counter++;
    });
  }

  // 第70行：重写 build —— 每次调用 setState 后，此方法都会被重新执行一次，
  // 用新数据生成新的 Widget 树，框架再与旧树做 diff，只重绘变化的部分。
  @override
  Widget build(BuildContext context) {
    // 第78行：Scaffold 是 Material 页面骨架，提供标题栏、内容区、悬浮按钮等标准布局槽位。
    return Scaffold(
      // 第79行：appBar 槽位放置顶部标题栏。
      appBar: AppBar(
        // 第83行：标题栏背景色取自主题的 inversePrimary（与主色互补的浅色），
        // Theme.of(context) 沿组件树向上找到最近的 MaterialApp 主题。
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 第86行：标题栏文字。widget.title 里的 widget 是 State 提供的引用，
        // 指向绑定给本 State 的 MyHomePage 配置实例，从而取出构造时传入的 title。
        title: Text(widget.title),
      ),
      // 第88行：body 是页面主体内容区，用 Center 让内容水平垂直居中。
      body: Center(
        // 第91行：Column 纵向排列子组件，是常用布局 Widget。
        child: Column(
          // 第105行：mainAxisAlignment: .center 主轴（Column 的主轴是竖直方向）居中对齐。
          mainAxisAlignment: .center,
          // 第106行：children 接收一个 Widget 列表，按声明顺序自上而下排列。
          children: [
            // 第107行：const Text —— 提示文案，内容固定所以声明为编译期常量。
            const Text('You have pushed the button this many times:'),
            // 第108行：显示当前计数值。
            Text(
              // 第109行：'$_counter' 是 Dart 字符串插值：把变量值嵌入字符串。
              '$_counter',
              // 第110行：文字样式取自主题的 headlineMedium（大号标题字号）。
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // 第115行：floatingActionButton 槽位放置右下角悬浮按钮（FAB）。
      floatingActionButton: FloatingActionButton(
        // 第116行：onPressed 绑定点击回调——每次点击执行 _incrementCounter。
        onPressed: _incrementCounter,
        // 第117行：tooltip 长按按钮时显示的提示文字。
        tooltip: 'Increment',
        // 第118行：按钮内的图标，Icons.add 是内置"+"图标。
        child: const Icon(Icons.add),
      ),
    );
  }
}
