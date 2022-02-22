import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      child: GameWidget(
        game: Klotski(),
      ),
    ),
  ));
}

class Piece extends SpriteComponent {
  Piece({
    required Sprite sprite,
  }) : super(sprite: sprite);
}

enum Direction { up, down, left, right }

class Klotski extends FlameGame with PanDetector {
  bool running = true;
  late double tileWidth;
  Piece? current;
  late SpriteComponent victory;
  late AudioPlayer playingBGM;

  @override
  void onPanDown(DragDownInfo info) {
    if (running) {
      children.any((element) {
        var touchPoint = info.eventPosition.game;
        if (element is Piece &&
            element.containsPoint(touchPoint) &&
            _potentialMoves(element).isNotEmpty) {
          FlameAudio.audioCache.play('pickup.mp3');
          current = element;
          return true;
        }
        return false;
      });
    }
    super.onPanDown(info);
  }

  List<Direction> _potentialMoves(Piece piece) {
    List<Direction> potentialPawnMoves(Piece piece) {
      List<Direction> directions = [];
      bool canMoveUp = piece.y != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y - tileWidth / 2)));
      if (canMoveUp) {
        directions.add(Direction.up);
      }

      bool canMoveDown = piece.y != tileWidth * 4 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y + tileWidth * 1.5)));
      if (canMoveDown) {
        directions.add(Direction.down);
      }

      bool canMoveLeft = piece.x != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth / 2)));
      if (canMoveLeft) {
        directions.add(Direction.left);
      }

      bool canMoveRight = piece.x != tileWidth * 3 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth * 1.5, piece.y + tileWidth / 2)));

      if (canMoveRight) {
        directions.add(Direction.right);
      }
      return directions;
    }

    List<Direction> potentialCommanderMoves(Piece piece) {
      List<Direction> directions = [];
      bool canMoveUp = piece.y != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y - tileWidth / 2))) &&
          !children.any(((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 1.5, piece.y - tileWidth / 2))));

      if (canMoveUp) {
        directions.add(Direction.up);
      }

      bool canMoveDown = piece.y != tileWidth * 3 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth / 2, piece.y + tileWidth * 2.5))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 1.5, piece.y + tileWidth * 2.5)));
      if (canMoveDown) {
        directions.add(Direction.down);
      }

      bool canMoveLeft = piece.x != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth / 2))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth * 1.5)));
      if (canMoveLeft) {
        directions.add(Direction.left);
      }

      bool canMoveRight = piece.x != tileWidth * 3 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 2.5, piece.y + tileWidth / 2))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 2.5, piece.y + tileWidth * 1.5)));
      if (canMoveRight) {
        directions.add(Direction.right);
      }

      return directions;
    }

    List<Direction> potentialVerticalRectangleMoves(Piece piece) {
      List<Direction> directions = [];

      bool canMoveUp = piece.y != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y - tileWidth / 2)));
      if (canMoveUp) {
        directions.add(Direction.up);
      }

      bool canMoveDown = piece.y != tileWidth * 3 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y + tileWidth * 2.5)));
      if (canMoveDown) {
        directions.add(Direction.down);
      }

      bool canMoveLeft = piece.x != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth / 2))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth * 1.5)));
      if (canMoveLeft) {
        directions.add(Direction.left);
      }

      bool canMoveRight = piece.x != tileWidth * 3 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 1.5, piece.y + tileWidth / 2))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 1.5, piece.y + tileWidth * 1.5)));
      if (canMoveRight) {
        directions.add(Direction.right);
      }

      return directions;
    }

    List<Direction> potentialHorizontalRectangleMoves(Piece piece) {
      List<Direction> directions = [];

      bool canMoveUp = piece.y != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth / 2, piece.y - tileWidth / 2))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth * 1.5, piece.y - tileWidth / 2)));
      if (canMoveUp) {
        directions.add(Direction.up);
      }

      bool canMoveDown = piece.y != tileWidth * 4 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth / 2, piece.y + tileWidth * 1.5))) &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(Vector2(
                  piece.x + tileWidth * 1.5, piece.y + tileWidth * 1.5)));
      if (canMoveDown) {
        directions.add(Direction.down);
      }

      bool canMoveLeft = piece.x != 0 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x - tileWidth / 2, piece.y + tileWidth / 2)));
      if (canMoveLeft) {
        directions.add(Direction.left);
      }

      bool canMoveRight = piece.x != tileWidth * 2 &&
          !children.any((element) =>
              element is Piece &&
              element.containsPoint(
                  Vector2(piece.x + tileWidth * 2.5, piece.y + tileWidth / 2)));
      if (canMoveRight) {
        directions.add(Direction.right);
      }

      return directions;
    }

    if (piece.width == piece.height) {
      //pawn
      if (piece.width == tileWidth) {
        return potentialPawnMoves(piece);
      } // commander
      else {
        return potentialCommanderMoves(piece);
      }
    } else if (piece.height - piece.width == piece.width) {
      return potentialVerticalRectangleMoves(piece);
    } else {
      return potentialHorizontalRectangleMoves(piece);
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (current != null && running) {
      var touchPoint = info.eventPosition.game;
      var delta = info.delta.game;
      var potentialMoves = _potentialMoves(current!);
      if (delta.x > 0) {
        potentialMoves.any((element) {
          if (element == Direction.right) {
            if (touchPoint.x >= current!.x + current!.width + tileWidth / 2) {
              current!.x = current!.x + tileWidth;
            }
            return true;
          }
          return false;
        });
      } else {
        potentialMoves.any((element) {
          if (element == Direction.left) {
            if (touchPoint.x + tileWidth / 2 <= current!.x) {
              current!.x = current!.x - tileWidth;
            }
            return true;
          }
          return false;
        });
      }
      if (delta.y > 0) {
        potentialMoves.any((element) {
          if (element == Direction.down) {
            if (touchPoint.y >= current!.y + current!.height + tileWidth / 2) {
              current!.y = current!.y + tileWidth;
            }
            return true;
          }
          return false;
        });
      } else {
        potentialMoves.any((element) {
          if (element == Direction.up) {
            if (touchPoint.y + tileWidth / 2 <= current!.y) {
              current!.y = current!.y - tileWidth;
            }
            return true;
          }
          return false;
        });
      }
    }
    super.onPanUpdate(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (running) {
      if (current != null) {
        FlameAudio.audioCache.play('dropoff.mp3');
      }
      current = null;
      children.any((element) {
        if (element is Piece &&
            element.width == element.height &&
            element.width == tileWidth * 2) {
          if (element.y == tileWidth * 3 && element.x == tileWidth) {
            victory.setOpacity(1);
            playingBGM.pause();
            FlameAudio.audioCache.play('winner.mp3');
            running = false;
          }
          return true;
        }
        return false;
      });
      super.onPanEnd(info);
    }
  }

  @override
  void onPanCancel() {
    if (running) {
      current = null;
    }
    super.onPanCancel();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    playingBGM = await FlameAudio.audioCache.loop('rain.mp3', volume: 0.2);
    tileWidth = (size / 4).x;
    add(SpriteComponent(
      sprite: Sprite(
        await images.load('lubu.jpg'),
      ),
    )
      ..x = 0
      ..y = 0
      ..width = tileWidth * 4
      ..height = tileWidth * 5);

    add(SpriteComponent(sprite: Sprite(await images.load('huarongdao.jpg')))
      ..x = tileWidth
      ..y = tileWidth * 4
      ..width = tileWidth * 2
      ..height = tileWidth);

    add(Piece(
      sprite: Sprite(await images.load('caocao.jpg')),
    )
      ..x = tileWidth
      ..y = tileWidth
      ..width = tileWidth * 2
      ..height = tileWidth * 2);

    var pawn = await images.load('pawn.jpg');
    var pawn2 = await images.load('pawn2.jpg');
    add(Piece(
      sprite: Sprite(pawn),
    )
      ..x = 0
      ..y = 0
      ..width = tileWidth
      ..height = tileWidth);
    add(Piece(
      sprite: Sprite(pawn2),
    )
      ..x = tileWidth * 3
      ..y = 0
      ..width = tileWidth
      ..height = tileWidth);
    add(Piece(
      sprite: Sprite(pawn),
    )
      ..x = tileWidth * 1
      ..y = tileWidth * 3
      ..width = tileWidth
      ..height = tileWidth);
    add(Piece(
      sprite: Sprite(pawn2),
    )
      ..x = tileWidth * 2
      ..y = tileWidth * 3
      ..width = tileWidth
      ..height = tileWidth);

    add(Piece(
      sprite: Sprite(await images.load('zhangfei.jpg')),
    )
      ..x = 0
      ..y = tileWidth
      ..width = tileWidth
      ..height = tileWidth * 2);

    add(Piece(
      sprite: Sprite(await images.load('zhaoyun.jpg')),
    )
      ..x = tileWidth * 3
      ..y = tileWidth
      ..width = tileWidth
      ..height = tileWidth * 2);

    add(Piece(
      sprite: Sprite(await images.load('machao.jpg')),
    )
      ..x = 0
      ..y = tileWidth * 3
      ..width = tileWidth
      ..height = tileWidth * 2);

    add(Piece(
      sprite: Sprite(await images.load('guanyu.jpg')),
    )
      ..x = tileWidth
      ..y = 0
      ..width = tileWidth * 2
      ..height = tileWidth);

    add(Piece(
      sprite: Sprite(await images.load('huangzhong.jpg')),
    )
      ..x = tileWidth * 3
      ..y = tileWidth * 3
      ..width = tileWidth
      ..height = tileWidth * 2);

    var map = await images.load('map.jpg');
    var remainingY = size.y - tileWidth * 5;
    var scaleFactor = _getTargetDimension(Vector2(tileWidth * 4, remainingY),
        Vector2(map.width.toDouble(), map.height.toDouble()));
    add(SpriteComponent(
      sprite: Sprite(
        map,
      ),
    )
      ..scale = Vector2(scaleFactor, scaleFactor)
      ..x = 0
      ..y = tileWidth * 5);

    var round = await images.load('round.png');
    var spriteComponent = SpriteComponent(sprite: Sprite(round))
      ..x = tileWidth * 2
      ..y = tileWidth * 5
      ..width = tileWidth * 2
      ..height = (round.height * tileWidth * 2) / round.width
      ..anchor = Anchor.topCenter;
    add(spriteComponent);

    victory = SpriteComponent(
      sprite: Sprite(
        await images.load('victory.png'),
      ),
    )
      ..x = tileWidth * 2
      ..y = tileWidth * 2.5
      ..width = tileWidth * 2
      ..anchor = Anchor.center
      ..height = tileWidth;
    victory.scale = Vector2(2, 2);
    victory.setOpacity(0);
    add(victory);
  }

  double _getTargetDimension(Vector2 target, Vector2 source) {
    if (target.x * source.y < target.y * source.x) {
      var xScale = source.x / target.x;
      var yScale = source.y / target.y;
      if (xScale < yScale) {
        return 1 / yScale;
      } else {
        return 1 / xScale;
      }
    } else {
      var xScale = target.x / source.x;
      var yScale = target.y / source.y;
      if (xScale > yScale) {
        return xScale;
      } else {
        return yScale;
      }
    }
  }
}
