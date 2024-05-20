import 'package:supabase_flutter/supabase_flutter.dart';

Future<SupabaseClient> initializeSupabase() async {
  await Supabase.initialize(
    url: 'https://ieczccbopoftaobhqmwz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImllY3pjY2JvcG9mdGFvYmhxbXd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUwNzAwNTIsImV4cCI6MjAzMDY0NjA1Mn0.i3zdyASAic6SLr6IKbxTmcksu69Xb8zFb7n_Eg9w0UU', // Replace with your Supabase anon key
  );
  return Supabase.instance.client;
}
