import 'dart:math';

void main() {
  int r1Count = 4; // 8 players = 4 matches in R1
  int winRounds = 3;
  double canvasMargin = 20.0;
  double participantListTotalWidth = 210.0;
  double roundColumnWidth = 120.0;
  double centerGapWidth = 120.0;

  double width = canvasMargin * 2 + participantListTotalWidth +
        (max(0, winRounds - 1) * roundColumnWidth) * 2 +
        centerGapWidth + participantListTotalWidth;
        
  print("Computed Width: \$width");
}
