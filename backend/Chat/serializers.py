from rest_framework import serializers
from .models import Chat, Message

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = '__all__'

class ChatSerializer(serializers.ModelSerializer):
    messages = serializers.SerializerMethodField()
    class Meta:
        model = Chat
        fields = '__all__'

    def get_messages(self, instance):
        messages = []
        for message in Message.objects.filter(chat = instance):
            messages.append(message.message)
        return messages