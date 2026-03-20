import 'package:core/constants/api.dart';
import 'package:core/http.dart';
import 'package:core/models/feedback.model.dart';
import 'package:core/sqllite/sqlite.dart';

final FeedbackTable = SqlTable<FeedbackModel>(
  fields: [
    Field(name: 'id', type: 'TEXT NOT NULL', isPrimaryKey: true),
    Field(name: 'message', type: 'TEXT NOT NULL'),
    Field(name: 'images', type: 'JSON NOT NULL'),
    Field(name: 'created_at', type: 'TEXT NOT NULL'),
    Field(name: 'updated_at', type: 'TEXT NOT NULL'),
  ],
  name: 'feedback',
  toModel: FeedbackModel.fromJson,
  toJson: (item) => item.toJson(),
);

class FeedbackService {
  static Future<void> sendFeedback(String message) async {

    

    // final response = await Http.post('${API_URL}/app/v1/feedback', body: {
    //   'message': message,
    // });
  }
}
