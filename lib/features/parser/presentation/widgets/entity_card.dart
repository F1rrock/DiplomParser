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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(
            height: 8.0,
          ),
          Text(
            entity.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'category: ${entity.category}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                  Text(
                    entity.attributes.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5.0,
              ),
            ],
          ),
          const SizedBox(
            height: 6.0,
          ),
        ],
      ),
    );
  }
}
