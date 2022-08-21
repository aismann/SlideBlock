//
//  GameObject.cpp
//  SlideBlock
//
//  Created by Harry Nguyen on 11/29/16.
//
//

#include "GameObject.h"
#include "GameDefine.h"
#define TIME_RUNACTION 0.05

GameObject::GameObject() {}

GameObject::~GameObject() {}

void GameObject::setHeadAndLastMatrix(const Vec2& headMatrix, const Vec2& lastMatrix) {
  this->headMatrix = headMatrix;
  this->lastMatrix = lastMatrix;
  if(headMatrix.x == lastMatrix.x) {
    this->typeDirection = VERTICAL;
  } else {
    this->typeDirection = HORIZONTAL;
  }
  lengthObject = lastMatrix.x  - headMatrix.x;
  heightObject = lastMatrix.y - headMatrix.y;
}

void GameObject::setPositionObject(const Vec2& pos) {
  this->setAnchorPoint(Vec2::ZERO);
  this->setPosition(pos);
}

void GameObject::runActionGameWin(const Vec2& pos) {
  auto action1 = MoveTo::create(TIME_RUNACTION*2.0, pos);
  this->runAction(Sequence::create(action1, NULL));
}

void GameObject::createWithFileName(const char* fileName) {
  Sprite::initWithFile(fileName);
}

Vec2 GameObject::getLastMatrix() {
  return lastMatrix;
}

Vec2 GameObject::getHeadMatrix() {
  return headMatrix;
}

void GameObject::movePosition(const Vec2& position, const Vec2& newHeadMatrix, const Vec2& newLastMatrix) {
  this->headMatrix = newHeadMatrix;
  this->lastMatrix = newLastMatrix;
  this->setPosition(position);
}

int GameObject::getLengthObject() {
  return lengthObject;
}

int GameObject::getHeightObject() {
  return heightObject;
}

void GameObject::setTypeObject(int typeObject) {
  this->typeObject = typeObject;
}

int GameObject::getTypeObject() {
  return typeObject;
}

int GameObject::getTypeDirection() {
  return typeDirection;
}
