#!/bin/#!/usr/bin/env bash

for i in de de_base de_extended de_devops; do
	make BASE=ubuntu_1804_$i all
done
