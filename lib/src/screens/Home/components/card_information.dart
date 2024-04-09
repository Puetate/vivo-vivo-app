import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vivo_vivo_app/src/domain/models/incident_type.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class CardInformation extends StatefulWidget {
  final List<IncidentType> optionsIncidents;
  final void Function(int incidentTypeID) onTap;
  final double size;

  const CardInformation({
    super.key,
    required this.optionsIncidents,
    required this.onTap,
    required this.size,
  });

  @override
  State<CardInformation> createState() => _CardInformationState();
}

class _CardInformationState extends State<CardInformation> {
  int? _value = 0;
  @override
  Widget build(BuildContext context) {
    final Size sizeLayout = AppLayout.getSize(context);

    return Card(
      shadowColor: Styles.primaryColor,
      surfaceTintColor: Styles.primaryColor,
      shape: Styles.rounded(),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: sizeLayout.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Seleccione el tipo de incidente",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                    height:
                        10), // Espacio entre el título y la lista de ChoiceChip
                Wrap(
                  spacing: 5, // Espacio entre los ChoiceChip
                  children: List.generate(
                    widget.optionsIncidents.length,
                    (index) {
                      return ChoiceChip(
                        selectedColor: Styles.blue.withOpacity(0.7),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (_value == index)
                                ? const Icon(Icons.check)
                                : const SizedBox(),
                            const SizedBox(
                                width: 5), // Espacio entre el icono y el texto
                            Flexible(
                              child: Text(
                                widget.optionsIncidents[index].incidentTypeName,
                                style: const TextStyle(
                                  fontSize: 14, // Tamaño de fuente deseado
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          if (!selected) {
                            _value = 0;
                            widget.onTap(
                                widget.optionsIncidents[0].incidentTypeId);
                          } else {
                            setState(() {
                              _value = selected ? index : null;
                            });
                            widget.onTap(
                                widget.optionsIncidents[index].incidentTypeId);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
