import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/incident_group.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class CardInformation extends StatefulWidget {
  final List<IncidentGroup>? incidentsGroups;
  final void Function(int incidentTypeID) onTap;
  final double size;

  const CardInformation(
      {super.key,
      required this.onTap,
      required this.size,
      this.incidentsGroups});

  @override
  State<CardInformation> createState() => _CardInformationState();
}

class _CardInformationState extends State<CardInformation> {
  int? _value = 0;

  @override
  void didUpdateWidget(covariant CardInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Verificar si hay grupos y tipos de incidentes
    if (widget.incidentsGroups != null &&
        widget.incidentsGroups!.isNotEmpty &&
        widget.incidentsGroups!.first.incidentTypes.isNotEmpty &&
        _value == 0) {
      // Seleccionar por defecto el primer IncidentType
      _value = widget.incidentsGroups!.first.incidentTypes.first.incidentTypeId;
      // Notificar la selección inicial
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTap(_value!);
      });
    }
  }

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
                const SizedBox(
                    height:
                        10), // Espacio entre el título y la lista de ChoiceChip
                // Iterar sobre los grupos
                ...widget.incidentsGroups!.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mostrar el nombre del grupo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          entry.incidentTypeHierarchyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      // Mostrar los ChoiceChip correspondientes al grupo
                      Wrap(
                        spacing: 5, // Espacio entre los ChoiceChip
                        children: List.generate(
                          entry.incidentTypes.length,
                          (index) {
                            final incident = entry.incidentTypes[index];
                            return ChoiceChip(
                              selectedColor: Styles.blue.withOpacity(0.7),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (_value == incident.incidentTypeId)
                                      ? const Icon(Icons.check)
                                      : const SizedBox(),
                                  const SizedBox(
                                      width:
                                          5), // Espacio entre el icono y el texto
                                  Flexible(
                                    child: Text(
                                      incident.incidentTypeName,
                                      style: const TextStyle(
                                        fontSize:
                                            14, // Tamaño de fuente deseado
                                      ),
                                      textAlign: TextAlign.left,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              selected: _value == incident.incidentTypeId,
                              onSelected: (bool selected) {
                                if (!selected) {
                                  _value =
                                      entry.incidentTypes[0].incidentTypeId;
                                  widget.onTap(
                                      entry.incidentTypes[0].incidentTypeId);
                                } else {
                                  setState(() {
                                    _value = selected
                                        ? incident.incidentTypeId
                                        : null;
                                  });
                                  widget.onTap(incident.incidentTypeId);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
