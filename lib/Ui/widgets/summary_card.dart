import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  const SummaryCard({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return    Card(
                elevation: 0,
                color: Colors.white,
                
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Column(
                    children: [
                      Text( '$count', style: TextStyle(fontSize: 22,
                      fontWeight:FontWeight.bold
                      ),),
                      Text('$title')
                    ],
                  ),
                ),
              );
  }
}