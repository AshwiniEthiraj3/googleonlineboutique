#!/usr/bin/python
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import grpc
import demo_pb2
import demo_pb2_grpc
from logger import getJSONLogger

logger = getJSONLogger('recommendationservice-client')

if __name__ == "__main__":
    # 🔧 Read environment variables (with sensible Docker defaults)
    port = os.getenv("PORT", "8080")
    product_catalog_addr = os.getenv("PRODUCT_CATALOG_SERVICE_ADDR", "productcatalogservice:3550")
    ad_service_addr = os.getenv("AD_SERVICE_ADDR", "adservice:9555")

    logger.info(f"Starting RecommendationService client on port {port}")
    logger.info(f"Connecting to ProductCatalogService at {product_catalog_addr}")
    logger.info(f"Connecting to AdService at {ad_service_addr}")

    # 🧠 Connect to the running Recommendation Service (self)
    channel = grpc.insecure_channel(f"0.0.0.0:{port}")
    stub = demo_pb2_grpc.RecommendationServiceStub(channel)

    # 🧾 Form test request
    request = demo_pb2.ListRecommendationsRequest(
        user_id="test-user",
        product_ids=["OLJCESPC7Z", "66VCHSJNUP"]
    )

    try:
        # 🚀 Make the gRPC call
        response = stub.ListRecommendations(request)
        logger.info(f"Received recommendation response: {response}")
    except grpc.RpcError as e:
        logger.error(f"gRPC call failed: {e.code()} - {e.details()}")
        logger.error("Check that the RecommendationService is running and accessible.")
