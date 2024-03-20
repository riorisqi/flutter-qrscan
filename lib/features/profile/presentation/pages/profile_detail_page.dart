import 'package:flutter/material.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 130),
              _profileCard(
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundImage: AssetImage(
                        "assets/images/cat.jpg"
                      )
                    ),
                    const SizedBox(height: 10),
                    _title("Rio Risqi Akbar Herlambang"),
                    _subTitle("Programmer")
                  ],
                ),
              ),
              const SizedBox(height: 15),
              _profileCard(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title("Title"),
                    _subTitle("Sub Title"),
                    const SizedBox(height: 15),
                    _title("Title"),
                    _subTitle("Sub Title"),
                    const SizedBox(height: 15),
                    _title("Title"),
                    _subTitle("Sub Title"),
                    const SizedBox(height: 15),
                    _title("Title"),
                    _subTitle("Sub Title"),
                    const SizedBox(height: 15),
                    _title("Title"),
                    _subTitle("Sub Title"),
                    const SizedBox(height: 15),
                    _title("Title"),
                    _subTitle("Sub Title"),
                  ],
                )
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(Widget widget){
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: widget
    );
  }

  Widget _title(String text){
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16
      ),
    );
  }

  Widget _subTitle(String text){
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16
      ),
    );
  }
}