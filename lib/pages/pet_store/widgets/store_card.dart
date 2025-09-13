import 'package:flutter/material.dart';
import 'package:pawfect_care/models/pet_store.dart';

class StoreCard extends StatelessWidget {
  final PetStore item;
  final int index;

  const StoreCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageContainer(),
              _buildContent()
            ]
        )
    );
  }

  Widget _buildImageContainer() {
    return Expanded(
      child: SizedBox(
          width: double.infinity,
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.pets,
                  size: 40,
                  color: Colors.red,
                ),
              );
            },
          )
      ),
    );
  }

  Widget _buildContent(){
    return Padding(padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(item.name, style: const TextStyle(fontSize: 18, fontWeight:
      FontWeight.w600),maxLines: 2, overflow: TextOverflow.ellipsis,),
          SizedBox(height: 4,),
          Text('₦${item.price.toStringAsFixed(2)}', style: TextStyle
            (fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue),),
          SizedBox(height: 4,),
          Text(item.description, style: TextStyle(fontSize: 14, fontWeight:
          FontWeight.w400),),


        ],
      ),
    );
  }
}