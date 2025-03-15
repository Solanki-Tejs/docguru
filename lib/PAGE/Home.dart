import 'dart:ui';
import 'package:docguru/PAGE/SignIn.dart';
import 'package:docguru/PAGE/setting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docguru/PAGE/ChatPage.dart';
import 'package:docguru/PAGE/UploadFile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> pageNames = [];
  List<String> CollactionNames = [];
  List<List<String>> chatMessages = [];
  List<bool> uploadStatuses = [];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPages();
  }

  // Loading pages and chat messages from SharedPreferences
  Future<void> loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pageCount = prefs.getInt('page_count') ?? 0;
    int? onPage = prefs.getInt("onPage") ?? 0;
    List<String> loadedPageNames = [];
    List<String> loadedCollactionNames = [];
    List<bool> loadedUploadStatuses = [];
    List<List<String>> loadedChatMessages = [];

    for (int i = 0; i < pageCount; i++) {
      loadedCollactionNames.add(prefs.getString('CollactionNames_${i}_name') ??
          "CollactionNames ${i + 1}");
      loadedPageNames.add(prefs.getString('page_${i}_name') ?? "Page ${i + 1}");

      loadedUploadStatuses
          .add(prefs.getBool('page_${i}_upload_status') ?? false);
      loadedChatMessages.add(prefs.getStringList('page_${i}_messages') ??
          []); // Loading the chat messages
    }

    setState(() {
      CollactionNames = loadedCollactionNames;
      pageNames = loadedPageNames;

      uploadStatuses = loadedUploadStatuses;
      chatMessages = loadedChatMessages;
      currentPageIndex = pageNames.isEmpty ? 0 : onPage;
    });
  }

  // Add a new page and initialize chat messages
  void addPage() {
    setState(() {
      CollactionNames.add("CollactionNames ${CollactionNames.length + 1}");
      pageNames.add("Page ${pageNames.length + 1}");

      uploadStatuses.add(false);
      chatMessages.add([]); // Initialize empty chat messages for the new page
      currentPageIndex = pageNames.length - 1; // Switch to the new page
      savePages();
    });
  }

  // Save pages and chat messages to SharedPreferences
  void savePages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('page_count', pageNames.length);

    for (int i = 0; i < pageNames.length; i++) {
      prefs.setString('page_${i}_name', pageNames[i]);
      prefs.setString('CollactionNames_${i}_name', CollactionNames[i]);
      prefs.setBool('page_${i}_upload_status', uploadStatuses[i]);
      prefs.setStringList(
          'page_${i}_messages', chatMessages[i]); // Save chat messages
    }
  }

  // Switch between pages
  void switchPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  // Update chat messages for the current page
  void addMessage(int pageIndex, String message) {
    setState(() {
      chatMessages[pageIndex].add(message);
    });
    savePages(); // Save after adding message
  }

  // Toggle upload status for the current page
  void toggleUploadStatus(int pageIndex) {
    setState(() {
      uploadStatuses[pageIndex] = !uploadStatuses[pageIndex];
    });
    savePages();
  }

  // Set the page name
  void setPageName(int pageIndex, String name, String Filename) {
    setState(() {
      CollactionNames[pageIndex] = Filename;
      pageNames[pageIndex] = name;
      print(CollactionNames);
    });
    savePages();
  }

  Future<void> logout() async {
    print("object");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    print(token);
    await pref.remove('token');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
        (Route) => false);
  }

  void clearChat(int index) {
    setState(() {
      chatMessages[index] = [];
    });
    savePages();
  }

  void deletePage(int index) {
    setState(() {
      CollactionNames.removeAt(index);
      pageNames.removeAt(index);
      uploadStatuses.removeAt(index);
      chatMessages.removeAt(index);
      if (currentPageIndex >= pageNames.length) {
        currentPageIndex = pageNames.isEmpty ? 0 : pageNames.length - 1;
      }
    });
    savePages();
  }

  @override
  Widget build(BuildContext context) {
    //screen size
    final Size size = MediaQuery.sizeOf(context);
    //Screen width
    double scrwidth = size.width;
    //Screen hight
    double scrheight = size.height;
    print(scrheight);
    print(scrwidth);

    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text("DocGuru", style: TextStyle(color: Colors.white)),
      ),
      drawer: Drawer(
        width: scrwidth / 1.2,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: const Color.fromARGB(255, 64, 63, 63).withOpacity(0.3),
              child: Column(
                children: [
                  SizedBox(
                    height: scrheight / 6,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          // color: Colors.transparent,
                          ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        // height: 100,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            CircleAvatar(),
                            Expanded(
                              child: Column(
                                children: [
                                  Center(
                                      child: Text(
                                    "Name",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  Center(
                                      child: Text("Email",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (int i = 0; i < pageNames.length; i++)
                          ListTile(
                            title: Text(pageNames[i],
                                style: TextStyle(color: Colors.white)),
                            trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert_sharp,
                                    color: Colors.white),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "Clear Chat",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          print("object1");
                                          clearChat(i);
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "Delete PDF",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          print("object");
                                          deletePage(i);
                                        },
                                      ),
                                    ]),
                            onTap: () {
                              switchPage(i);
                              Navigator.pop(context); // Close the drawer
                            },
                          ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.white70, thickness: 0.5),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.add, color: Colors.white),
                        title: Text("Add Page",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          addPage();
                          Navigator.pop(context); // Close the drawer
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.white),
                        title: Text(
                          'Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Setting()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          logout();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Builder(
          builder: (context) {
            return pageNames.isEmpty
                ? Center(
                    child: Text("No Pages Created",
                        style: TextStyle(fontSize: 24)))
                : uploadStatuses[currentPageIndex]
                    ? Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Color(0xffb048ff),
                            Color(0xff262ea1),
                            Color(0xff000000),
                            Color(0xff000000)
                          ],
                          stops: [0.1, 0.3, 0.7, 0.85],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )),
                        child: ChatPage(
                          pageName: pageNames[currentPageIndex],
                          pageIndex: currentPageIndex,
                          messages: chatMessages[currentPageIndex],
                          onMessagesUpdated: (updatedMessages) {
                            setState(() {
                              chatMessages[currentPageIndex] = updatedMessages;
                            });
                            savePages();
                          },
                        ),
                      )
                    : UploadFile(
                        toggleUploadStatus: () =>
                            toggleUploadStatus(currentPageIndex),
                        pageIndex: currentPageIndex,
                        onNameChange: (name, Filename) =>
                            setPageName(currentPageIndex, name, Filename),
                      );
          },
        ),
      ),
    );
  }
}
