import 'package:flutter/material.dart';
import './components/create_product_form.dart';


class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Create Product'),
               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
            ),
            const SliverPadding(
              padding:  EdgeInsets.all(20.0),
              sliver: SliverToBoxAdapter(
                child:  CreateProductForm(),
              ),
            )
            
          ]
        )
      ),
    );
  }
}