import firebase_admin
from firebase_admin import credentials, firestore, messaging
from flask import Flask, jsonify, render_template, request

