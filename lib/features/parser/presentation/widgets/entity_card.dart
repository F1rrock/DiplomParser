import 'package:flutter/material.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

class EntityCard extends StatelessWidget {
  const EntityCard({Key? key, required this.entity}) : super(key: key);

  final ObjectEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            entity.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Row(
            children: <Widget>[
              const SizedBox(
                width: 5.0,
              ),
              Text(
                'category: ${entity.category}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            entity.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
        ],
      ),
    );
  }
}
