from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from Chat.models import Chat, Message
from Chat.serializers import ChatSerializer, MessageSerializer
from users.models import Patient, Doctor
from images.models import Image
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework import generics

class ChatCreateView(APIView):
    serializer_class = ChatSerializer

    def post(self, request, *args, **kwargs):
        data = request.data
        image_static_id = data['static_id']
        image = Image.objects.filter(static_id = image_static_id).first()
        if not image:
            return Response({"message" : "NO such img"}, status=status.HTTP_400_BAD_REQUEST)
        patient = image.patient
        doctor = image.doctor
        try:

            chat = Chat.objects.create(image = image, patient = patient, doctor = doctor)
        except Exception as e:
            return Response({"message" : str(e)}, status=status.HTTP_400_BAD_REQUEST)
        serializer = ChatSerializer(chat)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class MessageCreateView(APIView):
    serializer_class = MessageSerializer

    def post(self, request, *args, **kwargs):
        data = request.data
        serializer = MessageSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message":"YAYYYYY", "data" : serializer.data}, status = status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

@api_view(['GET'])
def list_chat_view(request):
    if request.method == 'GET':
        try:
            patient = Patient.objects.get(auth_user=request.user)
            image = Image.objects.get(patient=patient)
            doctor = image.doctor

            
            chats = Chat.objects.filter(patient=patient)
            print(patient.static_id)
            serializer = ChatSerializer(chats, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

        except (Patient.DoesNotExist, Image.DoesNotExist, Chat.DoesNotExist) as e:
            return Response({"message": "Patient, Image, or Chat not found"}, status=status.HTTP_404_NOT_FOUND)
        
class ListMessageView(APIView):
    serializer_class = MessageSerializer   
    def get(self, request):
        chat_static_id = request.query_params.get('chat_static_id')
        print(chat_static_id)
        chat = Chat.objects.filter(static_id = chat_static_id).first()
        if not chat:
            return Response({"message" : "No such chat"}, status = status.HTTP_400_BAD_REQUEST)           
        message = Message.objects.filter(chat = chat).order_by('-timestamp')
        serializer = MessageSerializer(message, many=True)
        return Response({"data": serializer.data}, status=status.HTTP_200_OK)       

