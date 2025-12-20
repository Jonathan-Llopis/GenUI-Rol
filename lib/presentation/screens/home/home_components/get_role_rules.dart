import 'package:flutter/material.dart';

class GetRoleRules extends StatelessWidget {
  const GetRoleRules({
    super.key,
    required this.implementedRolRules,
  });

  final Map<String, String> implementedRolRules;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85,
        mainAxisExtent: 180,
      ),
      itemCount: implementedRolRules.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: AssetImage('assets/images/${implementedRolRules.keys.elementAt(index)}.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.black45,
                BlendMode.darken,
              ),
            ),
          ),
          child: Card(
            color: Colors.transparent,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Acción al tocar la tarjeta
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      implementedRolRules.values.elementAt(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
