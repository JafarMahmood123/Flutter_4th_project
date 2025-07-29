import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:user_flutter_project/data/models/Hotel.dart';
import 'package:user_flutter_project/ui/viewmodels/hotel_reservation_viewmodel.dart';

class HotelReservationScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelReservationScreen({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelReservationViewModel()..fetchRooms(hotel.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reserve at ${hotel.name}'),
        ),
        body: Consumer<HotelReservationViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select your dates:',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          viewModel.startDate == null
                              ? 'Select Start Date'
                              : 'Start Date: ${DateFormat('EEE, MMM d, yyyy').format(viewModel.startDate!)}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: viewModel.startDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            viewModel.setStartDate(pickedDate);
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          viewModel.endDate == null
                              ? 'Select End Date'
                              : 'End Date: ${DateFormat('EEE, MMM d, yyyy').format(viewModel.endDate!)}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: viewModel.endDate ?? (viewModel.startDate ?? DateTime.now()).add(const Duration(days: 1)),
                            firstDate: (viewModel.startDate ?? DateTime.now()).add(const Duration(days: 1)),
                            lastDate: DateTime.now().add(const Duration(days: 366)),
                          );
                          if (pickedDate != null) {
                            viewModel.setEndDate(pickedDate);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number of People:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: viewModel.numberOfPeople > 1
                                    ? () => viewModel.setNumberOfPeople(viewModel.numberOfPeople - 1)
                                    : null,
                              ),
                              Text(
                                '${viewModel.numberOfPeople}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => viewModel.setNumberOfPeople(viewModel.numberOfPeople + 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Select a Room:',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : viewModel.rooms.isEmpty
                          ? const Center(child: Text('No rooms available for the selected criteria.'))
                          : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: viewModel.rooms.length,
                        itemBuilder: (context, index) {
                          final room = viewModel.rooms[index];
                          final isSelected = viewModel.selectedRoom == room;
                          return GestureDetector(
                            onTap: () => viewModel.showRoomDetails(room),
                            child: Card(
                              elevation: isSelected ? 8 : 2,
                              color: isSelected ? Theme.of(context).primaryColorLight : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Room ${room.roomNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Max: ${room.maxOccupancy} guests'),
                                    Text('\$${room.price.toStringAsFixed(2)} / night'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      if (viewModel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                            final success = await viewModel.submitBooking(hotel.id);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Reservation successful!')),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                              viewModel.isLoading ? 'Submitting...' : 'Confirm Reservation'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (viewModel.roomForDetails != null)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.all(24.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Room ${viewModel.roomForDetails!.roomNumber}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text('Max Occupancy: ${viewModel.roomForDetails!.maxOccupancy}'),
                              Text('Price: \$${viewModel.roomForDetails!.price.toStringAsFixed(2)} / night'),
                              const SizedBox(height: 8),
                              Text(viewModel.roomForDetails!.description),
                              const SizedBox(height: 16),
                              Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                              viewModel.isFetchingAmenities
                                  ? const Center(child: CircularProgressIndicator())
                                  : Wrap(
                                spacing: 8.0,
                                children: viewModel.roomAmenities
                                    .map((amenity) => Chip(label: Text(amenity.name)))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => viewModel.cancelRoomSelection(),
                                    child: const Text('Back'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => viewModel.selectRoom(viewModel.roomForDetails!),
                                    child: const Text('Select Room'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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