//
//  CollisionConstants.h
//  SheepScape
//
//  Created by KEVIN on 02/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

static const uint32_t sheepCategory = 0x01 << 0;
static const uint32_t wallCategory = 0x01 << 1;
static const uint32_t checkPointCategory = 0x01 << 10;
static const uint32_t rainAreaCategory = 0x01 << 11;

#define SHEEP_WIDTH 10
#define SHEEP_GLOW_WIDTH 5

#define FINAL_WIDTH SHEEP_WIDTH*3
#define FINAL_GLOW_WIDTH SHEEP_GLOW_WIDTH

#define START_WIDTH SHEEP_WIDTH*3
#define START_GLOW_WIDTH SHEEP_GLOW_WIDTH