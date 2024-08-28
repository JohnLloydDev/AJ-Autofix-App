import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> reviews = [
    {
      "name": "Donna Bins",
      "rating": 4.5,
      "review": "Lorem ipsum dolor sit amet."
    },
    {
      "name": "Ashutosh Pandey",
      "rating": 4.5,
      "review": "Lorem ipsum dolor sit amet."
    },
    {
      "name": "Kristin Watson",
      "rating": 4.5,
      "review": "Lorem ipsum dolor sit amet."
    },
    {
      "name": "Jerome Bell",
      "rating": 4.5,
      "review": "Lorem ipsum dolor sit amet."
    },
  ];

  void _addReview(String name, double rating, String review) {
    setState(() {
      reviews.add({"name": name, "rating": rating, "review": review});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reviews[index]['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < reviews[index]['rating']
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 5),
                Text(reviews[index]['review']),
              ],
            ),
            trailing: Text(reviews[index]['rating'].toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReviewDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0;
        TextEditingController reviewController = TextEditingController();

        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Rate the service',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = (index + 1).toDouble();
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Write your review',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (reviewController.text.isNotEmpty && rating > 0) {
                    _addReview('New User', rating, reviewController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
