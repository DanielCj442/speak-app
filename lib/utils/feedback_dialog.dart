import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class FeedbackDialog extends StatefulWidget {
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  double _rating = 0.0;

  Future<void> sendFeedback(String feedback) async {
    final url = Uri.parse('https://DanCJ.pythonanywhere.com/sendfeedback');
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'feedback': "RATING: ${_rating}\n FEEDBACK: ${feedback}"}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback enviado correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al enviar el feedback: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        color: Theme.of(context).primaryColorDark,
        elevation: 3,
        borderOnForeground: false,
        
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enviar Feedback',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
              ),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: '¡Dinos en qué podemos mejorar!'),
                      maxLines: 3,
                    ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      final feedback = _controller.text;
                      if (feedback.isNotEmpty) {
                        sendFeedback(feedback);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('El feedback no puede estar vacío')),
                        );
                      }
                    },
                    child: Text('Enviar', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
