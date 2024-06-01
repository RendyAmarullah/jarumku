import 'package:flutter/material.dart';

class ProfileInfoItem extends StatelessWidget {
  const ProfileInfoItem({
    super.key,
    required this.icon,
    required this.label,
    
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  
  
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Row(children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 8),
            
            Center(
              child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
              child: Text(label,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),
            )
            )
          ]),
        ),
        
       
      ],
    );
  }
}