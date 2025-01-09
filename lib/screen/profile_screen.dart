import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Icon(Icons.person_outline, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 32),

            // Settings List
            _settingsGroup(
              'Video preference',
              [
                _settingsItem('Download Option', onTap: () {}),
                _settingsItem('Video playback options', onTap: () {}),
              ],
            ),
            SizedBox(height: 16),

            _settingsGroup(
              'Account Settings',
              [
                _settingsItem('Email Notification Preferences', onTap: () {}),
                _settingsItem('Learning Reminders', onTap: () {}),
              ],
            ),
            SizedBox(height: 16),

            _settingsGroup(
              'Account Settings',
              [
                _settingsItem('About LearnHub', onTap: () {}),
                _settingsItem('Frequently Asked Questions', onTap: () {}),
                _settingsItem('Share the LearnHub App', onTap: () {}),
              ],
            ),
            SizedBox(height: 32),

            // Logout Button
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Log Out'),
                      content: Text('Log Out from LearnHub?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Tutup dialog
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<AuthProvider>(context, listen: false)
                                .signOut();
                            // Tutup dialog dan kembali ke SignInScreen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: 3,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment_outlined),
              activeIcon: Icon(Icons.comment),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: '•',
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        ...items,
      ],
    );
  }

  Widget _settingsItem(String title, {required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
