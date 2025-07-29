import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/ui/viewmodels/hotel_viewmodel.dart';
import 'package:user_flutter_project/ui/views/hotel_reservation_screen.dart';

class HotelScreen extends StatelessWidget {
  final String hotelId;

  const HotelScreen({Key? key, required this.hotelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HotelViewModel()..fetchHotelById(hotelId),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Consumer<HotelViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null || viewModel.hotel == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(viewModel.errorMessage ?? 'Hotel not found.'),
                ),
              );
            }

            final hotel = viewModel.hotel!;

            return Stack(
              children: [
                Hero(
                  tag: 'hotel-image-${hotel.id}',
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(hotel.pictureUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) => {},
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 0.9,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 80), // Add padding for the button
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      hotel.starRate.toStringAsFixed(1),
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 24),
                                    Icon(Icons.king_bed_outlined, color: Theme.of(context).primaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${hotel.numberOfRooms} rooms',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money, color: Colors.green[700], size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      viewModel.priceRange,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 24),
                                    if (viewModel.propertyType != null) ...[
                                      Icon(Icons.business, color: Theme.of(context).primaryColor, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        viewModel.propertyType!.name,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Divider(),
                                const SizedBox(height: 16),
                                Text(
                                  'About ${hotel.name}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  hotel.description,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                if (viewModel.amenities.isNotEmpty) ...[
                                  Text(
                                    'Amenities',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: viewModel.amenities.map((amenity) => Chip(label: Text(amenity.name))).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HotelReservationScreen(hotel: hotel),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Reserve'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
